push!(LOAD_PATH, "./")
using MriData
using DtiModel
using LinearAlgebra
using LsqFit
using Statistics

X, Y, Z = size(imgdata)

# matrix of input parameters
xdata = [b g]

# initial guess for fit parameters
P0 = [1, 0.5, 0, 0, 0.5, 0, 0.5]  # [S0, Dxx, Dxy, Dxz, Dyx, Dyy, Dyz, Dzz]
numparams = length(P0)

# initialize map arrays
fitmap = zeros(X, Y, numparams) # fit parameter map
eigvalmap = zeros(X, Y, 3) # eigenvalue map
eigvecmap = zeros(X, Y, 3) # eigenvector map
MDmap = zeros(X, Y)	# mean diffusivity map
FAmap = zeros(X, Y)	# fractional anisotropy map

for x = 1:X
	for y = 1:Y
		if !isnan(imgdata[x, y, 1])
			S = imgdata[x, y, :]
			S0 = maximum(S)
			S /= S0

			fit = curve_fit(multimodel, xdata, S, P0)

			P = fit.param
			P[1] *= S0; 

			fitmap[x, y, :] = P; 

			D = [P[2] P[3] P[4]
				 P[3] P[5] P[6]
				 P[4] P[6] P[7]]

			eigvec = eigvecs(D)
			eigval = eigvals(D)
			maxeigval, maxeigval_index = findmax(eigval)
			primary_eigvec = eigvec[:, maxeigval_index]
			eigvalmap[x, y, :] = eigval
			eigvecmap[x, y, :] = primary_eigvec

			MD = mean(eigval)
			MDmap[x, y] = MD

			dd = eigval .- MD
			FA = sqrt((3 * sum(dd .* dd)) / (2 * sum(eigval .* eigval)))
			FAmap[x, y] = FA
		end
	end
end

using DelimitedFiles

writedlm("./fitdata/fit.csv", fitmap, ',')
writedlm("./fitdata/eigval.csv", eigvalmap, ',')
writedlm("./fitdata/eigvec.csv", eigvecmap, ',')
writedlm("./fitdata/MD.csv", MDmap, ',')
writedlm("./fitdata/FA.csv", FAmap, ',')
