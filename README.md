# Lua introduction

Lua means "moon" in Portugese, it is an interpreted scripting language developed by PUC-Rio in Brazil.

It is:

* Dynamically typed
* Loosely typed
* Imperative
* Functional
* Object-oriented


## Elements of syntax

c.f: lesson_1.lua

* Optional semicolon usage, except in one very specific case.
* Blocks are implicit and are ended with "end"
* Return values are implicit
* The concatenation operator is ".." (yeah, I know)

Does not need to be multiline, just seperated:   
```   
function factorial(n)if n<=0 then return 1 else return n*factorial(n-1)end end
```   

Exception to the semicolon rule is:   
```
foo = bar
;(faz or baz).value()
```   
Without semicolon can be interpreted as:   
```
	foo = bar(faz or baz).value()
```   
Where bar is assumed to be a function taking parameter "faz or baz" and returning a table with a function named "value".

## Types

* boolean
* nil
* number
* string
* function
* table
* userdata

## Boolean / nil

There is a boolean "type" in lua, which can only be of value "true" or "false".   
Everything in lua evaluates to true or false following this simple rule:

* false: The "false" boolean, and anything that evaluates to "nil" (i.e: "nil" and any unset values)
* true: EVERYTHING else

Lua uses lazy evaluation, and will return the value that triggers the successful evaluation, not just the boolean.

e.g:
```
print("Am I alive?" and "Hello, world!") -- "Hello, world!"
print("Am I alive?" or "Hello, world!") -- "Am I alive?"
```

Lua programmers can take advantage of these in interesting ways:  
```
-- Detect unset values
if (val) then
	print(val)
end

-- Do optional values
function mymult(a, b)
	return a * (b or 2)
end

-- Trinary expression
function sign(n)
	return (n>0 and 1 or -1) -- Equivalant to C: (n>0 ? 1 : -1)
end
```

## Number

In Lua, all numbers (char, int, float, short, long, unsigned, bignum, etc...) are just "number". Lua will do the work required to stay efficient.
Numbers range from -BIGNUM to BIGNUM, have double precision.

There is also a special value "math.huge" which represents infinity, it is a number like any other but doesn't have a numerical value, it is used in mathematical functions to simulate the behaviour expected at infinity.   
e.g: ``` math.atan(math.huge) -- returns math.pi/2 ```

## String

Works pretty much like string in any other language. Lua's string library is very powerful and uses pattern-matching (not regex).   
String library functions that expect a single character simply only read the first character of the provided string.
