--Collection of common patterns and useful
--modifications to existing types

--Logic

function _G.is_f(v)
  return type(v) == 'function'
end

function _G.is_t(v)
  return type(v) == 'table'
end

function _G.is_n(v)
  return type(v) == 'number'
end

function _G.is_s(v)
  return type(v) == 'string'
end

function _G.case(value)
  return function(cases)
    local case
    if is_f(cases[value]) then
      case = cases[value]()
    elseif is_f(cases[type(value)]) then
      case = cases[type(value)]()
    else
      error("Case '"..tostring(value).."' not defined")
    end
    return case
  end
end

-- Wrapper to make 
function _G.it(cond)

end

function _G.blank(str)
  return not (str and #string > 0)
end

--Iterators

function _G.range(start,fin)
  local i = start-1
  return function()
    i = i+1
    if i <= fin then
      return i
    else
      return nil
    end
  end
end

function _G.count(amount)
  return range(1,amount)
end

-- Iterate over the keys in a table
function _G.keys(tbl)
  local lastKey = nil
  local t = tbl

  return function()
    lastKey, _ = next(tbl, lastKey)
    return lastKey
  end
end

-- Iterate over the values in a table
function _G.vals(tbl)
  local lastKey = nil
  local t = tbl

  return function()
    lastKey, v = next(tbl, lastKey)
    return v
  end
end

-- Iterate over multiple tables
function _G.tables(...)
  local t = {...}
  local tmp = {...}

  if #tmp==0 then
    return function() end, nil, nil
  end
  local function mult_ipairs_it(t, i)
    i = i+1
    for j=1,#t do
      local val = t[j][i]
      if val == nil then return val end
      tmp[j] = val
    end
    return i, unpack(tmp)
  end
  return mult_ipairs_it, t, 0
end

-- Iterate over all pattern matches
-- equivalent to pairs('string'/'pattern')
function _G.matches(string, pattern)
  return string:gfind(pattern)
end

-- Functional style methods

-- Wrap a table as chainable list
function List(tbl)
  mt = getmetatable(tbl).__index
  mt["map"]    = map
  mt["filter"] = filter
  mt["reduce"] = reduce
  mt["detect"] = detect
  mt["each"]   = each
  setmetatable(tbl,mt)
  return tbl
end

-- When given a string, map acts as 'pluck', returning
-- the value of a key. So, it assumes an array of tables
-- in that case.
function map(list, func)
  local newtbl = {}
  if is_s(func) then
    newtbl = map(list, function(v)
      return v[func]
    end)
  else
    for i,v in pairs(list) do
      newtbl[i] = func(v)
    end
  end
  return newtbl
end

function filter(list, func)
  local newtbl= {}
  for i,v in pairs(list) do
    if func(v) then
      newtbl[i]=v
    end
  end
  return newtbl
end

function _G.fold(list, val, func)	
  for i in vals(list) do
		val = func(val, i)
	end	
	return val
end

-- While fold can be used to implement reduce,
-- it's more efficient this way
function _G.reduce(list, func)
  val = func(list[1],list[2])
  for i=3, #list do
    val = func(val, list[i])
  end
  return val
end

function _G.detect(list, func)
	for k,v in pairs(list) do
		if func(v) then return v end
	end	
	return nil	
end

-- Common functions
_G.fn = {
   mod = math.mod;
   pow = math.pow;
   add = function(n,m) return n + m end;
   sub = function(n,m) return n - m end;
   mul = function(n,m) return n * m end;
   div = function(n,m) return n / m end;
   gt  = function(n,m) return n > m end;
   lt  = function(n,m) return n < m end;
   eq  = function(n,m) return n == m end;
   le  = function(n,m) return n <= m end;
   ge  = function(n,m) return n >= m end;
   ne  = function(n,m) return n ~= m end;
}

--String methods

getmetatable("").__mod = function(str,...)
  str:gsub("(%b{})", function(w)
    w = w:sub(1,-1)
    return arg[w] or w 
  end)
  return str
end

getmetatable("").__mul = function(str,param)
  print("mul")
  local cat = ""

  if is_n(param) then
    s:rep(param)
  elseif is_t(param) then
  end

  print("endmul")
  return cat
end

getmetatable("").__div = function(str,pattern)
  local tbl = {}

  for match in matches(str,pattern) do
    table.insert(tbl,match)
  end
  setmetatable(tbl,{__div = function(src,replacement)
    return str:gsub(pattern,replacement)
  end})
  return tbl
end

function _G.puts(...)
  each(arg,print)
end

function _G.expose(tbl, name)
  _G[name] = tbl
end

