module MriData

using DelimitedFiles

# read b-values and gradient directions

datadir = "./mridata/"

b = readdlm(string(datadir, "b_values.csv"))
g = readdlm(string(datadir, "gradient_directions.csv"), ',')

# read diffusion-weighted image data

imgdir = string(datadir, "dw_image/")
imgfnames = readdir(imgdir)
numimg = length(imgfnames)
height, width = size(readdlm(string(imgdir, imgfnames[1]), ','))

imgdata = zeros(Float64, (height, width, numimg))

for i = 1:numimg
	imgdata[:, :, i] = readdlm(string(imgdir, imgfnames[i]), ',')
end

# export variables

export b
export g
export imgdata

end
