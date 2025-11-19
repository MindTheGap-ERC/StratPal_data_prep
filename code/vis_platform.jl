module Vis_Platform

using CarboKitten
using Unitful
using CairoMakie
using CarboKitten.Visualization
using CarboKitten.Export: read_slice

TAG = "platform"

function make_summary_plot()
    fig = summary_plot("data/$(TAG).h5")
    save("figs/$(TAG).png", fig)
end

end

Vis_Platform.make_summary_plot()