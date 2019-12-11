using Dates


function gen_sleep_table(filename)
    r = r"\[(\d+-\d+-\d+ \d+:\d+)\] (.+)"
    
    timetable = open(filename) do io
        sort!([
            (
                m = match(r, l);
                (
                    DateTime(
                        m.captures[1],
                        dateformat"yyyy-mm-dd H:M"
                    ),
                    m.captures[end]
                )
            )
            for l in eachline(io)
        ]; by=x->x[1])
    end
    
    sleeptable = Dict{Int, Vector{Int}}()
    
    let
        curday = Date(0)
        curguard = 0
        fell_asleep = 0
        
        r2 = r"Guard #(\d+) begins shift"
        
        for (t, action) in timetable
            if (m = match(r2, action)) !== nothing
                curday = Date(round(t, Day))
                curguard = parse(Int, m.captures[1])
                if !haskey(sleeptable, curguard)
                    push!(
                        sleeptable, curguard => zeros(60)
                    )
                end
            elseif action == "falls asleep"
                fell_asleep = minute(t) + 1
            elseif action == "wakes up"
                sleeptable[curguard][fell_asleep : minute(t)] .+= 1
            end
        end
    end
    
    sleeptable
end


function findsleepiestminute(sleepstats)
    let max_sleep = 0, sleepiest_min = 0
        for i in 1 : 60
            amt_sleep = sleepstats[i]
            if amt_sleep > max_sleep
                sleepiest_min = i
                max_sleep = amt_sleep
            end
        end
        sleepiest_min, max_sleep
    end
end


function part1()
    sleeptable = gen_sleep_table("input.txt")
    
    best_sleeper = 0
    
    let max_sleep = 0
        for (guard, sleepstats) in sleeptable
            amt_sleep = sum(sleepstats)
            if amt_sleep > max_sleep
                best_sleeper = guard
                max_sleep = amt_sleep
            end
        end
    end
    
    sleepmin, _ = findsleepiestminute(sleeptable[best_sleeper])
    
    best_sleeper * (sleepmin - 1)
end


function part2()
    sleeptable = gen_sleep_table("input.txt")
    
    best_sleeper = 0
    max_sleep = 0
    sleepiest_minute = 0
    
    for (guard, sleepstats) in sleeptable
        sleepmin, amt_sleep = findsleepiestminute(sleepstats)
        if amt_sleep > max_sleep
            best_sleeper = guard
            max_sleep = amt_sleep
            sleepiest_minute = sleepmin
        end
    end
    
    best_sleeper * (sleepiest_minute - 1)
end
