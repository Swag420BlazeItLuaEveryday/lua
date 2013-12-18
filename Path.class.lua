-- **************************************************************
-- @class Path
--
-- Contains a path sequence object
-- 
-- Keys: "type","step"
-- Defaults: "point",0
--
-- **************************************************************

Path = {};
Path.__index = Path;

local Paths = {

	Line = function (depth)
		for i = 1, depth do
			coroutine.yield(i,0,0);
		end
	end,

	Platform = function (depth,width)
		for i = 0, math.floor((width-1)/2 + (width%2)/2) do
			for j = 0, (depth-1) do
					coroutine.yield(2*i,0,j);
			end

			if (2*i+1) <= (width-1) then
				for j = (depth-1),0,-1 do
						coroutine.yield(2*i+1,0,j);
				end
			end

		end
	end,

	Cube = function(depth,width,height)
		for k = 0, math.floor((height-1)/2 + (height%2)/2) do

			for i = 0, math.floor((width-1)/2 + (width%2)/2) do
				for j = 0, (depth-1) do

						coroutine.yield(2*i,2*k,j);
				end

				if (2*i+1) <= (width-1) then
					for j = (depth-1),0,-1 do

						coroutine.yield(2*i+1,2*k,j);
					end
				end
			end

			if (2*k+1) <= (height-1) then
				for i = math.floor((width-1)/2 + (width%2)/2),0,-1 do
					for j = (depth-1),0,-1 do

						coroutine.yield(2*i,2*k+1,j);
					end

					if i > 0 then
						for j = 0,(depth-1) do

							coroutine.yield(2*i-1,2*k+1,j);
						end
					end
				end
			end
		end
	end,

	MiningCube = function(depth,width,height)
		for k = 0, math.floor((height-1)/2 + (height%2)/2) do

			for i = 0, math.floor((width-1)/2 + (width%2)/2) do
				for j = 0, (depth-1) do

						coroutine.yield(2*i,6*k,j);
				end

				if (2*i+1) <= (width-1) then
					for j = (depth-1),0,-1 do

						coroutine.yield(2*i+1,6*k,j);
					end
				end
			end

			if (2*k+1) <= (height-1) then
				for i = math.floor((width-1)/2 + (width%2)/2),0,-1 do
					for j = (depth-1),0,-1 do

						coroutine.yield(2*i,6*k+3,j);
					end

					if i > 0 then
						for j = 0,(depth-1) do

							coroutine.yield(2*i-1,6*k+3,j);
						end
					end
				end
			end
		end
	end,

};

Path.__call = function(obj)

	if Paths[obj.type] ~= nil then
		if coroutine.status(obj.hCoroutine) == "dead" then
			obj.hCoroutine = coroutine.create(Paths[obj.type]);
		end
		local result = {coroutine.resume(obj.hCoroutine,unpack(obj.args))};
		table.remove(result,1);
		return result;
	end

end

function Path.new(...)
	local args = {...};
	local class = {};
	setmetatable(class,Path);

	local keys = {"type","args","step","hCoroutine"};
	local defaults = {"Line",{0},0,coroutine.create(function()end)};

	for i = 1,math.min(#args,#keys) do
		class[keys[i]] = args[i];
	end
	for i = #args+1,#keys do
		class[keys[i]] = defaults[i];
	end

	return class;
end

