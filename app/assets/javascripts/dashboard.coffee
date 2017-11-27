# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
sameHeight = ->
  $(".logos_empty_wrap .dashboard__pane--logos_empty").innerHeight('')
  $(".logos_wrap .dashboard__pane--logos").innerHeight('')
  col_height1 = $(".logos_wrap .dashboard__pane--logos").innerHeight()
  col_height2 = $(".logos_empty_wrap .dashboard__pane--logos_empty").innerHeight()
  if col_height1 > col_height2
    $(".logos_empty_wrap .dashboard__pane--logos_empty").innerHeight(col_height1)
  else
    $(".logos_wrap .dashboard__pane--logos").innerHeight(col_height2)

$(document).ready ->
  donutData = [
    {
      name: 'Evol8tion Curated'
      y: parseInt($("#segment-1").data('segment-1')) || 0
      color: '#EB65A8'
    }
    {
      name: 'Fonder Submitted'
      y: parseInt($("#segment-2").data('segment-2')) || 0
      color: '#4D5263'
    }
    {
      name: 'Evol8tion Generated'
      y: parseInt($("#segment-3").data('segment-3')) || 0
      color: '#DAE3F9'
    }
    {
      name: 'The Watchlist'
      y: parseInt($("#segment-4").data('segment-4')) || 0
      color: '#F0F0F0'
    }
  ]
  if $('#dashboard__donut')
    $('#dashboard__donut').highcharts
      chart:
        type: 'pie'
        backgroundColor: 'transparent'
        style: fontFamily: 'Open Sans'
      credits: enabled: false
      title: text: ''
      tooltip: enabled: false
      series: [ {
        data: donutData
        states: hover:
          enabled: false
          brightness: 0
        animation: false
        size: '100%'
        innerSize: '45%'
        showInLegend: false
        dataLabels: enabled: true
      } ]


  if $('#graph').length > 0
    $('#graph').highcharts
      chart:
        type: 'column'
        spacingTop: 33
        backgroundColor: null
        spacingRight: 22
        style:
          color: '#222f36'
          font: '12px "Lato", sans-serif'
      title: text: ''
      tooltip: shared: true
      xAxis:
        lineColor: null
        tickColor: null
        labels: style:
          color: 'rgba(0, 0, 0, 0.54)'
          font: '12px "Lato", sans-serif'
        crosshair: color: 'rgba(234,234,240,.36)'
        categories: gon.dates_range
      yAxis:
        gridLineColor: 'transparent'
        labels: style:
          color: 'rgba(0, 0, 0, 0.54)'
          font: '12px "Lato", sans-serif'
        title: text: ''
      legend: enabled: false
      colors: [
        'rgba(242,44,142,.7)'
        'rgba(38,46,70,.8)'
      ]
      series: [
        {
          data: gon.founder
          pointPadding: 0
          groupPadding: 0.24
          borderWidth: 0
          shadow: false
          name: 'New Founder Submitted Profiles'
        }
        {
          data: gon.founder_brand
          pointPadding: 0
          groupPadding: 0.24
          borderWidth: 0
          shadow: false
          name: 'New Watchlist Entries'
        }
      ]
      credits: enabled: false

  sameHeight()

  $(window).resize ->
    sameHeight()
