function graph(pqc, ccs, xGraph){
  var graphs = Array.prototype.slice.call(document.getElementsByClassName('custom_graph'));
  if (graphs) {
    graphs.forEach(function(graph) {
        var graph_point = graph.getElementsByClassName('graph_point');
        var heightGraph = graph.offsetHeight;
        var widthGraph = graph.offsetWidth;
        var point_y_radius = parseFloat(graph_point[0].offsetHeight) / 2;
        var point_x_radius = parseFloat(graph_point[0].offsetWidth) / 2;
        var yGraph = (parseFloat(pqc) * 1.5) + parseFloat(ccs);
        var yPosPoint = (heightGraph / 25) * yGraph;
        if(yGraph == 0) {
          yPosPoint += point_y_radius;
        } else if(yGraph == 25) {
          yPosPoint -= point_y_radius;
        }
        var xPosPoint = (widthGraph / 10) * parseFloat(xGraph);
        if(xGraph == 0) {
          xPosPoint += point_x_radius;
        } else if(xGraph == 10) {
          xPosPoint -= point_x_radius;
        }
        graph_point[0].setAttribute("style", ('left: ' + xPosPoint + 'px; ' + 'bottom: ' + yPosPoint + 'px; '));
    });
  }
}

function generateAllGraphs(){
  var graphs = Array.prototype.slice.call(document.getElementsByClassName('custom_graph'));
  if (graphs) {
    graphs.forEach(function(graph) {
      var graph_point = graph.getElementsByClassName('graph_point');
      var point_y_radius = parseFloat(graph_point[0].offsetHeight) / 2;
      var point_x_radius = parseFloat(graph_point[0].offsetWidth) / 2;
      var yScore = parseFloat(graph.dataset.yScore);
      var xScore = parseFloat(graph.dataset.xScore);
      if(yScore || xScore) {
        var heightGraph = graph.offsetHeight;
        var widthGraph = graph.offsetWidth;
        var yPosPoint = (heightGraph / 25) * yScore;
        if(yScore == 0) {
          yPosPoint += point_y_radius;
        } else if(yScore == 25) {
          yPosPoint -= point_y_radius;
        }
        var xPosPoint = (widthGraph / 10) * parseFloat(xScore);
        if(xScore == 0) {
          xPosPoint += point_x_radius;
        } else if(xScore == 10) {
          xPosPoint -= point_x_radius;
        }
        graph_point[0].setAttribute("style", ('left: ' + xPosPoint + 'px; ' + 'bottom: ' + yPosPoint + 'px; '));
      }
    });
  }
}
