*! 1.0.0 Tom Palmer 8jan2010
program tsci, rclass 
syntax anything, [eform fieller]
* syntax gd segd gp segp cov (if poss)
local n = wordcount("`anything'")
tokenize `anything'
tempname gd segd gp segp cov ratio seratio z p
sca `gd' = `1'
sca `segd' = `2'
sca `gp' = `3'
sca `segp' = `4'
if "`n'" == "4" {
	sca `cov' = 0
}
else {
	sca `cov' = `5'
}
if "`fieller'" != "" {
	tempname f0 f1 f2 D r1 r2
	scalar `f0' = `gd'^2 - invnormal(.975)^2*`segd'^2
	scalar `f1' = `gp'^2 - invnormal(.975)^2*`segp'^2
	scalar `f2' = `gd'*`gp'
	scalar `D' = `f2'^2 - `f0'*`f1'
	if `D' > 0 {
		scalar `r1' = (`f2' - sqrt(`D'))/`f1'
		scalar `r2' = (`f2' + sqrt(`D'))/`f1'
		if `f1' > 0 { 
			di "Confidence interval is a closed interval [", `r1', "," `r2', "]"
			if "`eform'" != "" {
				di "Confidence interval is a closed interval [", exp(`r1'), "," exp(`r2'), "]"
			}
		}
		if `f1' < 0 { 
			di "Confidence interval is the union of two open intervals (-Inf, " `r2', "], [ " `r1', " +Inf)"
			if "`eform'" != "" {
				di "Confidence interval is the union of two open intervals (-Inf, " exp(`r2'), "], [ " exp(`r1'), " +Inf)"
			}
		}
	}
	else {
		di "No finite confidence interval exists other than the entire real line."
	}
}

sca `ratio' = `gd'/`gp'
sca `seratio' = sqrt((`segd'^2/`gp'^2) + (`gd'^2/`gp'^4)*`segp'^2 - 2*(`gd'/`gp'^3)*`cov')
sca `z' = abs(`ratio'/`seratio')
sca `p' = 2*normal(-1*`z')
di as res `ratio', `seratio', "(" `ratio' - invnormal(0.975)*`seratio' ", " `ratio' + invnormal(0.975)*`seratio' ")", "Z=" `z', "P=" `p'
if "`eform'" != "" {
di as res exp(`ratio'), "(" exp(`ratio' - invnormal(0.975)*`seratio') ", " exp(`ratio' + invnormal(0.975)*`seratio') ")", "P=" `p'
}
ret sca ratio = `ratio'
ret sca seratio = `seratio'
end
