function render_graph(container, nodes, links) {
  var width = 960,
    height = 500;

  var color = d3.scale.category20();
  function line_width(d) { return d.occurrences; };

   function line_class(d) {
     if(d.link_type == 'auxiliary') {
       return 'link auxiliary';
     } else {
       return 'link primary';
     };
   };

  var force = d3.layout.force();

  var drag = force.drag()
      .on("dragstart", dragstart);

  var svg = container.append("svg")
      .attr("width", width)
      .attr("height", height);

  var link = svg.selectAll(".link"),
      node = svg.selectAll(".node");

   force
     .nodes(nodes)
     .links(links)
     .size([width, height])
     .charge(-1100)
     .linkDistance(80)
     .on("tick", tick)
     .start();

   link = link.data(links)
     .enter().append("g")
     .attr("class", line_class)
     .append("line")
     .attr("stroke-width", function(d) { return line_width(d)+"px"; });

   node = svg.selectAll(".node")
     .data(nodes)
     .enter().append("g")
     .attr("class", "node")
     .on("dblclick", dblclick)
     .call(drag);

  node.append('circle')
    .attr("r", 24)
    .style("fill", function(d) {return color(d.searched); });

  node.append('text')
      .attr("dy", ".35em")
      .attr("text-anchor", "middle")
      .attr("class", "node-text")
      .text(function(d) { return d.name; });

  function tick() {
    link.attr("x1", function(d) { return d.source.x; })
        .attr("y1", function(d) { return d.source.y; })
        .attr("x2", function(d) { return d.target.x; })
        .attr("y2", function(d) { return d.target.y; });

    node.attr("transform", function(d) {
      return "translate(" + d.x + "," + d.y + ")";
    });
  };

  function dblclick(d) {
    d3.select(this).classed("fixed", d.fixed = false);
  }

  function dragstart(d) {
    d3.select(this).classed("fixed", d.fixed = true);
  }
}

$().ready(function() {
  render_graph(d3.select('#ingredients-graph'), gon.nodes, gon.edges);
})