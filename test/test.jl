function f(n)
    a = inv(rand(n,n))
    out = 0.0
    for j=1:n
        for i=1:n
            out += a[i,j]
        end
    end
    out
end
include("test2.jl")

f(1)
g(1)

Profile.clear()
@profile f(3*10^3)
@profile g(10^2)
using ProfileFile
ProfileFile.write_to_file()
