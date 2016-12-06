torch.setdefaulttensortype('torch.FloatTensor')
local nn = require 'nn'

local net = nn.Sequential()

-- compute the size of output layer from input dim/size
local in_size = 28
local num_class = 10 -- mnist
local in_dim = 1
local inp = torch.Tensor(in_dim, in_size, in_size)

-- first layer
net:add(nn.SpatialConvolutionPrune(in_dim,6,3,3))
net:add(nn.SpatialMaxPooling(2,2,2,2))
net:add(nn.Tanh())

-- second layer
net:add(nn.SpatialConvolutionPrune(6,16,3,3))
--net:add(nn.SpatialMaxPooling(2,2,2,2))
net:add(nn.Tanh())

-- third layer
net:add(nn.SpatialConvolutionPrune(16,36,4,4))
net:add(nn.SpatialMaxPooling(2,2,2,2))
net:add(nn.Tanh())

-- to find the size of fcn layer
local out_size = #(net:forward(inp))

-- reshape into a linear tensor
net:add(nn.View(-1))

-- output layer
net:add (nn.LinearPrune(out_size[1]*out_size[2]*out_size[3], 240))
net:add(nn.Tanh())
net:add (nn.LinearPrune(240, 160))
net:add(nn.Tanh())


-- final layer
net:add(nn.LinearPrune(160, num_class))

return net
