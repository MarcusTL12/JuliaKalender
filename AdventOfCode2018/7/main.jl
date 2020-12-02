using DataStructures


function makegraph(filename)
    open(filename) do io
        graph = Dict{Char, Set{Char}}()
        
        for l in eachline(io)
            a, b = (
                match(
                    r"Step (\w) must be finished before step (\w) can begin\.",
                    l
                ).captures
            )
            
            a = a[1]
            b = b[1]
            
            if !haskey(graph, a)
                graph[a] = Set([b])
            else
                push!(graph[a], b)
            end
        end
        
        for k in setdiff(union(values(graph)...), keys(graph))
            graph[k] = Set{Char}()
        end
        
        graph
    end
end


function makedualgraph(graph)
    dualgraph = Dict{Char, Set{Char}}()
    
    for (k, s) in graph
        for v in s
            if !haskey(dualgraph, v)
                dualgraph[v] = Set([k])
            else
                push!(dualgraph[v], k)
            end
        end
    end
    
    for k in setdiff(union(values(dualgraph)...), keys(dualgraph))
        dualgraph[k] = Set{Char}()
    end
    
    dualgraph
end


function part1()
    graph = makegraph("input.txt")
    dualgraph = makedualgraph(graph)
    
    roots = setdiff(keys(graph), union(values(graph)...))
    
    queue = SortedSet(roots)
    
    order = Char[]
    
    while !isempty(queue)
        node = pop!(queue)
        push!(order, node)
        
        for c in graph[node]
            if isempty(setdiff(dualgraph[c], order))
                push!(queue, c)
            end
        end
    end
    
    order |> String
end


function part2()
    graph = makegraph("input.txt")
    dualgraph = makedualgraph(graph)
    
    roots = setdiff(keys(graph), union(values(graph)...))
    product = collect(setdiff(keys(dualgraph), union(values(dualgraph)...)))[]
    
    queue = SortedSet(roots)
    done = Set{Char}()
    
    workers = 5
    basetime = 60
    
    jobs = Dict{Char, Int}()
    
    time_elapsed = 0
    
    while product ∉ done
        while workers > 0 && !isempty(queue)
            workers -= 1
            node = pop!(queue)
            push!(jobs, node => basetime + Int(node) - 64)
        end
        
        mtime = -1
        
        for (_, t) in jobs
            if mtime == -1
                mtime = t
            elseif t < mtime
                mtime = t
            end
        end
        
        time_elapsed += mtime
        
        justdone = Char[]
        
        for k in keys(jobs)
            jobs[k] -= mtime
            if jobs[k] == 0
                push!(justdone, k)
                delete!(jobs, k)
                workers += 1
            end
        end
        
        for node in justdone
            push!(done, node)
            for c in graph[node]
                if isempty(setdiff(dualgraph[c], done))
                    push!(queue, c)
                end
            end
        end
    end
    
    time_elapsed
end
