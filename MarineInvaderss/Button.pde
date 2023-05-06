class Button
{
  PVector Pos = new PVector(0,0); 
  float Width = 0;
  float Height = 0;
  color Color;
  String Text;
  Boolean Pressed = false;
  Boolean Clicked = false;
  
  Button(int x, int y, int w, int h, String t, int r, int g, int b)
  {
    Pos.x = x;
    Pos.y = y;
    Width = w;
    Height = h;
    Color = color(r, g, b);
    Text = t;
  }
  void update()
  {
    if (mousePressed == true && mouseButton == LEFT && Pressed == false)
    {
      Pressed = true;
      if (mouseX>= Pos.x && mouseX <= Pos.x+Width && mouseY >= Pos.y && mouseY <= Pos.y+Height)
      {
        Clicked = true;
      }
    } else
    {
      Clicked = false;
     
    }
    
    if(mousePressed !=true)
    {
      Pressed = false; 
    }
  }
  void render()
  {
    fill(Color);
    rect(Pos.x, Pos.y, Width, Height);

    fill(0);
    textAlign(CENTER,CENTER);
    textSize(18);
    text(Text,Pos.x+(Width/2), Pos.y+(Height/2));
  }
  boolean isClicked()
  {
    return Clicked;
  }
}
