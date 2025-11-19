

using CarboKitten
using Unitful

using CarboKitten.Visualization: summary_plot, wheeler_diagram, production_curve, sediment_profile!, coeval_lines!
import CairoMakie
using CarboKitten.Export: read_slice
using CairoMakie

const TAG = "platform"

function make_summary_plot()
    fig = summary_plot("data/$(TAG).h5")
    save("figs/$(TAG).png", fig)
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
    coeval_lines!(ax, header, data, [0.125:0.25:1.875;]u"Myr", linewidth = 3, color = :black, linestyle = :solid)
    save("figs/$(TAG)_profile.png", fig)
end

header, data = read_slice("data/$(TAG).h5", :profile)
fig = Figure(size=(1200, 1000))
ax = Axis(fig[1,1], title="sealevel curve", xlabel="sealevel [m]",
               limits=(nothing, (header.axes.t[1] |> in_units_of(u"Myr"),
                                 header.axes.t[end] |> in_units_of(u"Myr"))))
lines!(ax, header.sea_level |> in_units_of(u"m"), header.axes.t |> in_units_of(u"Myr"))
sep = [0.125:0.25:1.875;]
for i in sep
    lines!(ax,[-30, 30], [i, i], color = :black)
end

save("figs/test.png", fig)

#make_wheeler_diagram()
#make_summary_plot()
#make_production_curve()
#make_sed_profile()