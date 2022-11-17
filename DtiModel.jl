module DtiModel

using LinearAlgebra

function multimodel(xdata, P)
	S0 = P[1]
	D = [P[2] P[3] P[4]
		 P[3] P[5] P[6]
		 P[4] P[6] P[7]]
	b = xdata[:, 1]
	g = xdata[:, 2:4]

	gD = g*D
	gDg = gD*g'
	gDg_diag = gDg[diagind(gDg)]
	@. S0 * exp.(-b.*gDg_diag)
end

export multimodel

end
