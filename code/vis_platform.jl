module Vis_Platform

using CarboKitten
using Unitful
using GLMakie
using CarboKitten.Visualization
using CarboKitten.Export: read_slice

TAG = "platform"

function summary_plot()
    fig = summary_plot("data/$(TAG).h5")
    save("figs/$(TAG).png", fig)
end

end

Vis_Platform.make_summary_plots()