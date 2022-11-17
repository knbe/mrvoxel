using DelimitedFiles
using Plots
#using GR
Plots.gr()

MDmap = readdlm("./fitdata/MD.csv", ',')
FAmap = readdlm("./fitdata/FA.csv", ',')

#setcolormap(8)

gr(
   grid = false, 
   size = (900, 1000), 
   xtickfontsize = 15,
   ytickfontsize = 15,
   xguidefontsize = 18,
   yguidefontsize = 18,
   titlefontsize = 26,
   background_color = :transparent,
   foreground_color = "#8e24aa"
   )

heatmap(MDmap, 
		aspect_ratio = 1,
		xlim = (0, 96), 
		ylim = (0, 96), 
		xlabel = "x", 
		ylabel = "y",
		title = "Mean Diffusivity (MD)", 
		) 
savefig("./pngs/MDmap.png")

heatmap(FAmap, 
		aspect_ratio = 1,
		xlim = (0, 96), 
		ylim = (0, 96), 
		xlabel = "x", 
		ylabel = "y",
		title = "Fractional Anisotropy (FA)",
		) 
savefig("./pngs/FAmap.png")
