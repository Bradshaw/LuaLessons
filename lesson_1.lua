--[[
	Filename: lesson_1.lua

	Purpose: Demonstrate the particularities of Lua's syntax

	For example, this is a block comment.
]]

-- Let's write a quick function first
function factorial(n)
	if n<=0 then
		return 1 -- We know the answer for factorial(1) and factorial(0)
	else
		return n * factorial(n-1) -- and we can recursively define other values
	end
end


-- And let's print out some values...
for i=1,10 do
	print("factorial("..i..")\t= "..factorial(i))
end

-- Can you write a function that prints out the nth value in the fibonacci sequence?

function max(a,b)
	return (a>b and a or b)
end