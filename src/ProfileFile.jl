module ProfileFile
using Compat
P = Base.Profile

const def = "        - "
const pre_length = length(def)
const suffix = ".per"

# For each source file which has profiler-traces this writes a *.prof
# file. output = [:user, :all]
function write_to_file(;output=[:user,:all][1])
    if output==:all
        error("not implemented")
    end
    
    # adapted from Base.Profile
    data = P.fetch()
    lidict = P.getdict(data)
    iplist, n = P.count_flat(data)
    C_profile = false
    lilist, n = P.parse_flat(iplist, n, lidict, C_profile)

    p = P.liperm(lilist)
    lilist = lilist[p]  # now sorted by filename
    n = n[p]
    # combine
    j = 1
    for i = 2:length(lilist)
        if lilist[i] == lilist[j]
            n[j] += n[i]
            n[i] = 0
        else
            j = i
        end
    end
    keep = n .> 0
    n = n[keep]
    lilist = lilist[keep]

    if pre_length<ndigits(maximum(n))
        width = ndigits(maximum(n))
        # pad
        pre = " "^(width-pre_length)*def
    else
        width = pre_length
        pre = def
    end

    # Write to *.per files
    source = Any[]
    loadit = true
    for (i, (hits,line)) in enumerate(zip(n, lilist))
        fl = line.file
        ln = line.line
        if @compat startswith(fl, "none") # no file
            continue
        end
        if @compat !startswith(fl, "/") # TODO implement base-functions
            continue
        end

        if loadit
            # read the next source file
            source = readlines(open(fl, "r")) # read new file
            for (j,s) in enumerate(source)
                # add prefix
                source[j] = pre*s
            end
            loadit = false
        end
        # modify the line which is hit
        source[ln] = (" "^(width-ndigits(hits)-1) *
                      "$hits " *
                      source[ln][width+1:end])
        if lilist[i+1].file!=fl
            open(fl*suffix,"w") do io
                write(io, source)
            end
            loadit = true
        end            
    end
    return nothing
end
end
