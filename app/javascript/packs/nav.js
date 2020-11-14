//change active status
$(".nav li a").click(function() {
    $(this).parent().addClass('active').siblings().removeClass('active');
    $("#navbar").removeClass("in");    
});
  
  