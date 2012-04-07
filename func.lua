require "lang"

-- Function manipulation helpers.
_G.func = {}

function _G.func.chain(target,func)
  local old = target
  target = function(...)
    func(unpack(arg))
    return old(unpack(arg))
  end
  return target
end

function _G.func.displace(target,func)
  local old = target
  target = function(...)
    old(unpack(arg))
    return func(unpack(arg))
  end
  return target
end

function _G.func.curry(f,g)
  return function (...)
    return f(g(unpack(arg)))
  end
end

function _G.func.bind(func, ...)
  local bound = arg
  return function ()
    return func(unpack(bound))
  end
end
