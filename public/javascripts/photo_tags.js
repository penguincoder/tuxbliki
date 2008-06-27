function show_tag_at(xcoord, ycoord)
{
  $('photo_tag_box').style.top = (ycoord - 50) + 'px';
  $('photo_tag_box').style.left = (xcoord - 50) + 'px';
  $('photo_tag_box').style.display = 'block';
}

function hide_tag_box()
{
  $('photo_tag_box').style.display = 'none';
}

function set_coordinates(event)
{
  xcoord = (event.offsetX ? event.offsetX : (event.pageX - $('photo_block').offsetLeft));
  ycoord = (event.offsetY ? event.offsetY : (event.pageY - $('photo_block').offsetTop));
  show_tag_at(xcoord, ycoord);
}

