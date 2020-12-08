$('.dropbtn').on('click', function(event) {
    // Avoid following the href location when clicking
    event.preventDefault(); 
    // Avoid having the menu to close when clicking
    event.stopPropagation(); 
    // Re-add .open to parent sub-menu item
    if ($(this).parent().attr("class").split(/\s+/).includes('open')) {
        $(this).parent().removeClass('open');
    } else {
        $(this).parent().addClass('open');
    }
});

if (document.getElementById('notice').innerHTML.length !== 10 ) {
    document.getElementById('notice').style.display = "block";
}
if (document.getElementById('alert').innerHTML.length !== 10 ) {
    document.getElementById('alert').style.display = "block";
}