# Run a simple ALCAP model
using CarboKitten
using Unitful
using CarboKitten.Export: read_slice, read_volume, data_export, CSV
using DataFrames
using Random

Random.seed!(64849206)

const TAG = "platform"
const PATH = "data"

const PERIOD1 = 1.0u"Myr"
const PERIOD2 = 0.112u"Myr"
const AMPLITUDE1 = 20.0u"m"
const AMPLITUDE2 = 2.0u"m"

const FACIES = [
    ALCAP.Facies(
        viability_range = (4, 10),
        activation_range = (6, 10),
        maximum_growth_rate=500u"m/Myr",
        extinction_coefficient=0.8u"m^-1",
        saturation_intensity=60u"W/m^2",
        diffusion_coefficient=50.0u"m/yr"),
    ALCAP.Facies(
        viability_range = (4, 10),
        activation_range = (6, 10),
        maximum_growth_rate=400u"m/Myr",
        extinction_coefficient=0.1u"m^-1",
        saturation_intensity=60u"W/m^2",
        diffusion_coefficient=25.0u"m/yr"),
    ALCAP.Facies(
        viability_range = (4, 10),
        activation_range = (6, 10),
        maximum_growth_rate=100u"m/Myr",
        extinction_coefficient=0.005u"m^-1",
        saturation_intensity=60u"W/m^2",
        diffusion_coefficient=12.5u"m/yr")
]

const INPUT_INIT_RUN = ALCAP.Input(
    tag="$(TAG)_prerun",
    box=CarboKitten.Box{Coast}(grid_size=(161, 21), phys_scale=100.0u"m"),
    time=TimeProperties(
        Δt=0.0001u"Myr",
        steps=10000),
    ca_interval=1,
    initial_topography=(x, y) -> -x / 300.0,
    output=Dict(
            :profile => OutputSpec(slice = (:, 11), write_interval = 100),
            :topography => OutputSpec(slice = (:, :), write_interval = 1000)),
    sea_level=t -> 0 * u"m",
    subsidence_rate=50.0u"m/Myr",
    disintegration_rate=30.0u"m/Myr",
    insolation=400.0u"W/m^2",
    sediment_buffer_size=50,
    depositional_resolution=0.5u"m",
    cementation_time = 1.0u"kyr",
    facies=FACIES)

function get_init_topography(header, volume)    
    n_steps = size(volume.sediment_thickness)[3]
    bedrock = header.initial_topography .- (header.axes.t[end] - header.axes.t[1]) * header.subsidence_rate
    grid_size = (length(header.axes.x), length(header.axes.y))
    result = Array{Float64, 2}(undef, grid_size...)
    result[:, :] = (volume.sediment_thickness[:,:,n_steps] .+ bedrock) |> in_units_of(u"m")
end

println("Running initial model")
run_model(Model{ALCAP}, INPUT_INIT_RUN, "$(PATH)/$(TAG)_prerun.h5")
header, volume = read_volume("$(PATH)/$(TAG)_prerun.h5", :topography)
init_matrix = get_init_topography(header, volume)

const INPUT_MAIN_RUN = ALCAP.Input(
    tag="$TAG",
    box=CarboKitten.Box{Coast}(grid_size=(161, 21), phys_scale=100.0u"m"),
    time=TimeProperties(
        Δt=0.0001u"Myr",
        steps=20000),
    ca_interval=1,
    initial_topography=init_matrix * u"m",
    output=Dict(
            :profile => OutputSpec(slice = (:, 11), write_interval = 10),
            :topography => OutputSpec(slice = (:, :), write_interval = 100)),
    sea_level=t -> AMPLITUDE1 * cos(2π * t / PERIOD1) + AMPLITUDE2 * cos(2π * t / PERIOD2),
    subsidence_rate=30.0u"m/Myr",
    disintegration_rate=50.0u"m/Myr",
    insolation=400.0u"W/m^2",
    sediment_buffer_size=50,
    depositional_resolution=0.5u"m",
    cementation_time = 1.0u"kyr",
    facies=FACIES)

println("run main model")
run_model(Model{ALCAP}, INPUT_MAIN_RUN, "$(PATH)/$(TAG).h5")

function export_files()
    header, profile = read_slice("data/$(TAG).h5", :profile)
    columns = [profile[i] for i in [21, 41, 61, 81, 101, 121]]
    data_export(
        CSV(
            :stratigraphic_column => "$(PATH)/$(TAG)_sc.csv",
            :age_depth_model      => "$(PATH)/$(TAG)_adm.csv",
            :metadata => "$(PATH)/$(TAG)_metadata.toml",
            :water_depth => "$(PATH)/$(TAG)_wd.csv",
            :sediment_accumulation_curve => "$(PATH)/$(TAG)_sac.csv"),
        header,
        columns)
end

export_files()
