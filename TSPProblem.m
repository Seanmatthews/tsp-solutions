classdef TSPProblem < handle

    % The class wraps the elements of a travelling salesman problem
    % represented in the TSPLIB format. 
    
  properties
    name
    type
    comment
    dimension
    capacity
    edgeWeightType
    edgeWeightFormat
    edgeDataFormat
    nodeCoordType
    displayDataType
    X
    Y
  end

  methods (Access = public)
  
    function obj = TSPProblem(filepath)
      obj.X = [];
      obj.Y = [];
      spec = fopen(filepath, 'r');
      obj.loadSpecSection(spec);
    end

    % Puts data into Matlab graph representation
    function g = getGraph(obj)
        d = pdist([obj.X', obj.Y']);
        sqForm = squareform(d);
        g = graph(sqForm);
    end
  end

  methods (Access = private)

    % Load problem set specs
    function loadSpecSection(obj, spec)
      line = "";
      while line ~= "EOF"
        line = fgetl(spec);

        tmp = strsplit(line, ':');
        
        if startsWith("NAME", line, 'IgnoreCase', true)          
          obj.name = tmp(2);
        elseif startsWith("TYPE", line, 'IgnoreCase', true)
          obj.type = tmp(2);
        elseif startsWith("COMMENT", line, 'IgnoreCase', true)
          obj.comment = tmp(2);
        elseif startsWith("DIMENSION", line, 'IgnoreCase', true)
          obj.dimension = str2int(tmp(2));
        elseif startsWith("CAPACITY", line, 'IgnoreCase', true)
          obj.capacity = str2int(tmp(2));
        elseif startsWith("EDGE_WEIGHT_TYPE", line, 'IgnoreCase', true)
          obj.edgeWeightType = tmp(2);
        elseif startsWith("EDGE_WEIGHT_FORMAT", line, 'IgnoreCase', true)
          obj.edgeWeightFormat = tmp(2);
        elseif startsWith("EDGE_DATA_FORMAT", line, 'IgnoreCase', true)
          obj.edgeDataFormat = tmp(2);
        elseif startsWith("NODE_COORD_TYPE", line, 'IgnoreCase', true)
          obj.nodeCoordType = tmp(2);
        elseif startsWith("DISPLAY_DATA_TYPE", line, 'IgnoreCase', true)
          obj.displayDataType = tmp(2);
        elseif startsWith("NODE_COORD_SECTION", line, 'IgnoreCase', true)
          obj.parseNodes(spec);
          break;
        end
      end      
    end

    % Load node coordinates
    function parseNodes(obj, spec)
      line = fgetl(spec)
      while line ~= "EOF"
        n = strsplit(line);
        obj.X = [obj.X, str2double(n(2))];
        obj.Y = [obj.Y, str2double(n(3))];
        line = fgetl(spec);
      end
    end

  end

end


