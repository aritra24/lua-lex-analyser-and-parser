function fibonacci(n)
    if n<3 then
        return 1; 
    else
        return fibonacci(n-1) + fibonacci(n-2)
    end
end
function fibonacci1(n)
    if n<3 then
        return 1
    else
        return fibonacci1(n-1) + fibonacci(n-2)
    end
end

for n = 1, 16 do
    print(fibonacci(n))
end
io.write("...\n")
