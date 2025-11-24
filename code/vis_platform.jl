

using CarboKitten
using Unitful
import CarboKitten.Visualization: sediment_accumulation!
using CarboKitten.Visualization: summary_plot, wheeler_diagram, production_curve, sediment_profile!, coeval_lines!, wheeler_diagram!, sediment_accumulation!

import CairoMakie
using CarboKitten.Export: read_slice
using CairoMakie

const TAG = "platform"

function make_summary_plot()
    fig = summary_plot("data/$(TAG).h5")
    save("figs/$(TAG)_summary.png", fig)
end

function make_wheeler_diagram()
    header, data = read_slice("data/$(TAG).h5", :profile)
    fig = wheeler_diagram(header, data)
    save("figs/$(TAG)_wheeler_diagram.png", fig)
end

function make_production_curve()
    fig = production_curve("data/$(TAG).h5")
    save("figs/$(TAG)_production_curve.png", fig)
end

function make_sed_profile()
    header, data = read_slice("data/$(TAG).h5", :profile)
    fig = Figure(size=(1000, 600))
    ax = Axis(fig[1, 1])
    sediment_profile!(ax, header, data, show_unconformities = true, show_coeval_lines = false)
    coeval_lines!(ax, header, data, [0.125:0.25:1.875;]u"Myr", linewidth = 2, color = :black, linestyle = :solid)
    ax.title = "Platform Transect"
    save("figs/$(TAG)_profile.png", fig)
end

function make_sl_curve()
    header, data = read_slice("data/$(TAG).h5", :profile)
    fig = Figure(size=(1200, 1000))
    ax1 = Axis(fig[1,1], title="sealevel curve", xlabel="sealevel [m]",
                limits=(nothing, (header.axes.t[1] |> in_units_of(u"Myr"),
                                    header.axes.t[end] |> in_units_of(u"Myr"))))
    lines!(ax1, header.sea_level |> in_units_of(u"m"), header.axes.t |> in_units_of(u"Myr"))
    sep = [0.125:0.25:1.875;]
    for i in sep
        lines!(ax1,[-30, 30], [i, i], color = :black)
    end
    save("figs/$(TAG)_sl_systems_tracts.png", fig)
end

make_wheeler_diagram()
make_summary_plot()
make_production_curve()
make_sed_profile()
