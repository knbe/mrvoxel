
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
