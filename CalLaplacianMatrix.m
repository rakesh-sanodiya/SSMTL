function result=CalLaplacianMatrix(graph)
    result=diag(graph*ones(size(graph,1),1))-graph;
    clear graph;