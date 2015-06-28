function g(n)
    a = rand(n,n)
    out = 0.0
    for _ =1:n
        for j=1:n
            for i=1:n
                out += sin(a[i,j])
            end
        end
    end
    out
end
