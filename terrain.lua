terrain = {}

terrain.type = {}
terrain.type.err = -1
terrain.type.empty = 0
terrain.type.wall = 1
terrain.type.room = 2
terrain.type.door = 3
terrain.type.dead = 4
terrain.type.mark = 5
terrain.type.start = 6

function terrain.getgrid(i)
	return 2*i
end



function terrain.gettile(t, x, y)
	if x>=1 and x<=t.mazew and y>=1 and y<=t.mazeh then
		return t[x*2][y*2]
	else
		return terrain
	end
end

function terrain.newgrid(width, height, squx, squy)
	local t = {}
	t.mazew = width
	t.mazeh = height
	t.gridw = 2*width+1
	t.gridh = 2*height+1
	t.squx = squx or 32
	t.squy = squy or 24
	t.rooms = {}
	for i=1,t.gridw do
		t[i]={}
		for j=1,t.gridh do
			t[i][j]={}
			t[i][j].type = terrain.type.wall
			t[i][j].ent = {}
		end
	end
	return t
end

local clock = os.clock
function sleep(n)  -- seconds
  local t0 = clock()
  while clock() - t0 <= n do end
end

function terrain.print(t) -- Cette fonction est géniaaaale
	local s = ""
	for i=1,t.gridw do
		for j=1,t.gridh do
			if t[i][j].type==terrain.type.wall then
				s = s .. "#"
				--io.write("o")
			elseif t[i][j].type==terrain.type.room then
				s = s .. " "
			elseif t[i][j].type==terrain.type.door then
				s = s .. "."
			elseif t[i][j].type==terrain.type.dead then
				s = s .. "x"
			elseif t[i][j].type==terrain.type.empty then
				s = s .. " "
			elseif t[i][j].type==terrain.type.mark then
				if t[i][j].count ~= nil then
					s = s .. t[i][j].count
				else
					s = s .. ","
				end
			elseif t[i][j].type==terrain.type.start then
				s = s .. "X"
			else
				s = s .. "E"
				--io.write(" ")
			end
		end
		s = s .. "\n"
		--io.write("\n")
	end
	io.write(s)
	sleep(0.03)
	--io.read()
end

function terrain.maze(t, i, j)
	if i>=1 and i<=t.mazew and j>=1 and j<=t.mazeh then
		terrain.gettile(t, i, j).type=terrain.type.empty
		terrain.print(t)
		--terrain.draw(t)
		local f = {}
		f[1]="up"
		f[2]="down"
		f[3]="left"
		f[4]="right"
		for x=1,3 do
			local a,b = math.random(1,4),math.random(1,4)
			f[a],f[b]=f[b],f[a]
		end
		for x=1,4 do
			if f[x]=="up" then
				if terrain.gettile(t, i, j-1).type == terrain.type.wall then
					t[i*2][j*2-1].type = terrain.type.empty
					terrain.maze(t, i, j-1)
				end
			elseif f[x]=="down" then
				if terrain.gettile(t, i, j+1).type == terrain.type.wall then
					t[i*2][j*2+1].type = terrain.type.empty
					terrain.maze(t, i, j+1)
				end
			elseif f[x]=="left" then
				if terrain.gettile(t, i-1, j).type == terrain.type.wall then
					t[i*2-1][j*2].type = terrain.type.empty
					terrain.maze(t, i-1, j)
				end
			else 
				if terrain.gettile(t, i+1, j).type == terrain.type.wall then
					t[i*2+1][j*2].type = terrain.type.empty
					terrain.maze(t, i+1, j)
				end
			end
		end
		--terrain.gettile(t, i, j).type=terrain.type.empty
		terrain.print(t)
	end
end

function terrain.addroom(t)
	local x1
	local y1
	local x2
	local y2
	local bad = true
	local fuckit = 10
	while bad and fuckit > 0 do
		bad = false
		fuckit = fuckit - 1
		x1 = math.random(2,t.gridw-math.floor(t.gridw/4))
		y1 = math.random(2,t.gridh-math.floor(t.gridh/4))
		x2 = math.random(x1+1,t.gridw-1)
		y2 = math.random(y1+1,t.gridh-1)
		x1 = 2*math.floor(x1/2)-1
		y1 = 2*math.floor(y1/2)-1
		x2 = 2*math.floor(x2/2)+1
		y2 = 2*math.floor(y2/2)+1
		for i=x1,x2 do
			for j=y1,y2 do
				if t[i][j].type==terrain.type.room then
					bad = true
				end
			end
		end
		local smallest=math.max(t.gridw/20,t.gridh/20)
		local biggest=math.max(t.gridw/4,t.gridh/4)
		if x2-x1 < smallest or y2-y1 < smallest or x2-x1>biggest or y2-y1>biggest then
			bad = true
		end
		if x2-x1 < 4 or y2-y1 < 4 then
			bad = true
		end
		if (math.abs(x2-x1) > 2*math.abs(y2-y1)) or (math.abs(y2-y1) > 2*math.abs(x2-x1)) then
			bad = true
		end
	end
	if fuckit>1 then
		t.rooms[# t.rooms + 1] = {}
		t.rooms[# t.rooms].x1 = x1
		t.rooms[# t.rooms].x2 = x2
		t.rooms[# t.rooms].y1 = y1
		t.rooms[# t.rooms].y2 = y2
		for i=x1,x2 do
			for j=y1,y2 do
				if (i==x1 and j==y1) or (i==x1 and j==y2) or (i==x2 and j==y1) or (i==x2 and j==y2) then
					t[i][j].type=terrain.type.wall
				elseif (i==x1 or i==x2 or j==y1 or j==y2) and t[i][j].type~=terrain.type.wall then
					--[[if i==x1 and t[x1-1][j].type==wall then
						t[i][j].type=terrain.type.door
					elseif i==x2 and t[x2+1][j].type==wall then
						t[i][j].type=terrain.type.door
					elseif j==y1 and t[i][y1-1].type==wall then
						t[i][j].type=terrain.type.door
					elseif j==y2 and t[i][y2+1].type==wall then
						t[i][j].type=terrain.type.door
					else
						--t[i][j].type=terrain.type.wall
					end]]
					t[i][j].type=terrain.type.door
					t[i][j].roomnumber = # t.rooms
				elseif (i==x1 or i==x2 or j==y1 or j==y2) and t[i][j].type==terrain.type.wall then
					--donothing
				else
					t[i][j].type = terrain.type.room
					t[i][j].roomnumber = # t.rooms
				end
			end
			--terrain.print(ter)
		end
		return true
	else
		return false
	end
end

function terrain.removedead(t, i, j)
	t[i][j].type = terrain.type.mark
	local n = 0
	local f = {}
	f[1]="up"
	f[2]="down"
	f[3]="left"
	f[4]="right"
	for x=1,4 do
		if f[x]=="up" then
			if t[i][j-1].type ~= terrain.type.wall then
				n=n+1
			end
		elseif f[x]=="down" then
			if t[i][j+1].type ~= terrain.type.wall then
				n=n+1
			end
		elseif f[x]=="left" then
			if t[i-1][j].type ~= terrain.type.wall then
				n=n+1
			end
		else 
			if t[i+1][j].type ~= terrain.type.wall then
				n=n+1
			end
		end
	end
	if n==1 then
		t[i][j].type = terrain.type.wall
		t[i-1][j].type = terrain.type.wall
		t[i+1][j].type = terrain.type.wall
		t[i][j-1].type = terrain.type.wall
		t[i][j+1].type = terrain.type.wall
		--[[
		if i+2<t.mazew and t[i+2][j].type==terrain.type.empty then
			print("Calling right")
			terrain.removedead(t, i+2, j)
		end
		if i-2>0 and t[i-2][j].type==terrain.type.empty then
			print("Calling left")
			terrain.removedead(t, i+2, j)
		end
		if j+2<t.mazeh and t[i][j+2].type==terrain.type.empty then
			print("Calling down")
			terrain.removedead(t, i+2, j)
		end
		if j-2>0 and t[i][j-2].type==terrain.type.empty then
			print("Calling up")
			terrain.removedead(t, i+2, j)
		end
		]]
		terrain.print(t)
		deads = deads+1
	else
	end
end

function terrain.fillpath(t, x, y)
	if (x<1 or x>t.gridw-1) then return false end
	if (y<1 or y>t.gridh-1) then return false end
	if t[x][y].type == terrain.type.empty then
		t[x][y].type=terrain.type.mark
		t[x][y].count = (t[x][y].count or 0) + 1
		terrain.print(t)
		if t[x+1][y].type == terrain.type.empty then
			terrain.fillpath(t, x+1, y)
		elseif t[x-1][y].type == terrain.type.empty then
			terrain.fillpath(t, x-1, y)
		elseif t[x][y+1].type == terrain.type.empty then
			terrain.fillpath(t, x, y+1)
		else 
			terrain.fillpath(t, x, y-1)
		end
	end
end

function terrain.newdungeon(xs, ys, rooms, level)
	xs = xs or 15
	ys = ys or 15
	local ter = terrain.newgrid(xs,ys)
	x = math.random(1,ter.mazew)
	y = math.random(1,ter.mazeh)
	terrain.maze(ter, x, y)
	ter.level = level or 1
	--ter[2*x][2*y].type = terrain.type.start
	retry = 100
	rooms = rooms or 10
	while retry>0 and rooms>0 do
		if not terrain.addroom(ter) then
			retry = retry - 1
		else
			retry = 100
			rooms = rooms - 1
		end
	end
	deads = 1
	while deads > 0 do 
		deads = 0
		for i=1,ter.mazew do
			for j = 1,ter.mazeh do
				if ter[i*2][j*2].type==terrain.type.empty then
					terrain.removedead(ter, i*2, j*2)
				end
			end
		end
		--print("Completed a pass")
		terrain.print(ter)
	end
	return ter
end

terrain.newdungeon(10,30,20,1)