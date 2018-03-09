import 'dart:html';
import 'dart:math' as Math;

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:Frontend/D3Dart.dart' as d3;

import 'Threat.dart';

@Component(
  selector: "pie-chart",
  templateUrl: 'pie_chart.html',
  directives: const [CORE_DIRECTIVES, materialDirectives],
)
class PieComponent implements AfterViewInit {
  @ViewChild("containerPieChart")
  ElementRef element;
  HtmlElement htmlElement;
  d3.Selection host;
  d3.Selection svg;
  d3.Ordinal col;
  num width;
  num height;
  num radius;
  num sliceSize;
  var donutWidth = 75;
  var numberOfSlices;
  Math.Random random = new Math.Random();
  var MAX_LEVEL = 4;
  var MAX_THREATS = 1000;

  List<String> threatTypeList = new List<String>();
  List<Threat> threatList = new List<Threat>();
  Map<String, String> threatToColorMap = new Map<String, String>();

  ngAfterViewInit() {
    this.htmlElement = this.element.nativeElement;
    this.host = d3.selectElement(this.htmlElement);
    this.setup();
    this.setupThreatTypeList();
    this.setupThreatsList();
    this.numberOfSlices = this.threatList.length;
    this.sliceSize = d3.TWO_PI / numberOfSlices;
    this.buildSVG();
  }

  void setupThreatTypeList() {
    // mabye use List.from()
    this.threatTypeList.add("DDOS");
    this.threatToColorMap['DDOS'] = 'green';
    this.threatTypeList.add("Phishing");
    this.threatToColorMap['Phishing'] = 'blue';
    this.threatTypeList.add("Windows Virus");
    this.threatToColorMap['Windows Virus'] = 'red';
    this.threatTypeList.add("Malware");
    this.threatToColorMap['Malware'] = 'yellow';
    this.threatTypeList.add("Ransomware");
    this.threatToColorMap['Ransomware'] = 'orange';
    this.threatTypeList.add("Other");
    this.threatToColorMap['Other'] = 'lavender';
    this.threatTypeList.add("MAC virus");
    this.threatToColorMap['MAC virus'] = 'gold';
    this.threatTypeList.add("SQL injection");
    this.threatToColorMap['SQL injection'] = 'indigo';
  }

  void setupThreatsList() {
    for (var threatType in threatTypeList) {
      threatList.add(new Threat(threatType, 11, 'threat sub type',
          random.nextInt(4), random.nextInt(1000)));
    }
  }

  void setup() {
    this.width = 800;
    this.height = 800;
    this.radius = Math.min(width, height) / 2;
  }

  void buildOneArch(d3.Selection svg, String name, num radius, num innerRadius,
      num outerRadius, num startAngle, num endAngle, String fillColor) {
    var frameArc = new d3.Arc();
    frameArc.outerRadiusConst = radius;
    frameArc.innerRadiusConst = innerRadius;
    frameArc.startAngleConst = startAngle;
    frameArc.endAngleConst = endAngle;

    svg.append("path")
      ..attrFunc("d", frameArc)
      ..attr('stroke', 'black')
      ..attr('stroke-width', 3)
      ..attr('stroke-opacity', '1.0')
      ..attr('fill', 'white')
      ..attr('fill-opacity', '1.0');

    var fillArc = new d3.Arc();
    fillArc.outerRadiusConst = outerRadius;
    fillArc.innerRadiusConst = innerRadius;
    fillArc.startAngleConst = startAngle;
    fillArc.endAngleConst = endAngle;

    svg.append("path")
      ..attrFunc("d", fillArc)
      ..attr('stroke', 'white')
      ..attr('stroke-width', 3)
      ..attr('stroke-opacity', '0.0')
      ..attr('fill-opacity', '1.0')
      ..attr("fill", fillColor);

    var text = svg.append("text");
    text.attrFunc(
        "transform",
        (Object d, int i) => "translate(${ frameArc.centroid(d, i)
				  .join(",") })");
    text.attr("dy", ".35em");

    text.style.textAnchor = (d, i) => "middle";
    text.textFunc = (d, i) => name;
  }

  void buildSVG() {
    d3.Selection svg = d3.select("body").append("svg")
      ..attr("width", this.width)
      ..attr("height", this.height);

    // put circle in center of svg element
    var cx = 0;
    var cy = 0;
    var innerRadius = radius * 0.3;

    svg = svg.append("g");
    svg.attr("transform", "translate(${this.width / 2},${this.height / 2})");

    var circle = svg.append("circle")
      ..attr('cx', cx)
      ..attr('cy', cy)
      ..attr('r', innerRadius)
      ..attr('stroke', 'white')
      ..attr('stroke-width', 3)
      ..attr('stroke-opacity', '1.0')
      ..attr('fill', 'red')
      ..attr('fill-opacity', '1.0');

    var backgroundArc = new d3.Arc();
    backgroundArc.outerRadiusConst = radius;
    backgroundArc.innerRadiusConst = innerRadius;
    backgroundArc.startAngleConst = 0;
    backgroundArc.endAngleConst = d3.TWO_PI;

    svg.append("path")
      ..attrFunc("d", backgroundArc)
      ..attr('stroke', 'black')
      ..attr('stroke-width', 3)
      ..attr('fill', 'white')
      ..attr('fill-opacity', '1.0');

    for (var i = 0; i < this.threatList.length; i++) {
      Threat threat = threatList[i];
      num outerRadius = innerRadius + (radius - innerRadius) * threat.numberOfThreats / MAX_THREATS;
      buildOneArch(svg, threat.threatName, radius, innerRadius, outerRadius, i * sliceSize,
          (i+1) * sliceSize, threatToColorMap[threat.threatName]);
    }

    //    var pie = d3.Layout.pie();
//    pie.value = (Map d) => d["population"];
//
//    d3.csv("pie.csv").then((List data) {
//      var g = svg.selectAll(".arc").data(pie(data)).enter.append("g");
//
//      g.attr("class", "arc");
//
//      d3.Ordinal color = new d3.Ordinal();
//      color.range = [
//        "#98abc5",
//        "#8a89a6",
//        "#7b6888",
//        "#6b486b",
//        "#a05d56",
//        "#d0743c",
//        "#ff8c00"
//      ];
//
//      d3.Arc arc = new d3.Arc();
//      arc.outerRadiusConst = radius;
//      arc.innerRadiusConst = innerRadius;
//
//      var path = g.append("path");
//      path.attrFunc("d", arc);
//      path.style.fill =
//          (Object d, int i) => color((d as Map)["data"]["age"]).toString();
//
//      var text = g.append("text");
//      text.attrFunc(
//          "transform",
//          (Object d, int i) => "translate(${ arc.centroid(d, i)
//					  .join(",") })");
//      text.attr("dy", ".35em");
//
//      text.style.textAnchor = (d, i) => "middle";
//      text.textFunc = (d, i) => d["data"]["age"];
//    });
  }
}
