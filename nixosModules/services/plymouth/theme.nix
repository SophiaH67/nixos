{ pkgs, ... }: let
  logo = ./MESLogobios.png;
in
with pkgs;
  stdenv.mkDerivation {
    name = "plymouth-theme-soph-mes";

    src = writeTextFile {
      name = "theme.script";
      text = ''
// Screen size
screen.w = Window.GetWidth(0);
screen.h = Window.GetHeight(0);
screen.half.w = Window.GetWidth(0) / 2;
screen.half.h = Window.GetHeight(0) / 2;

// Question prompt
question = null;
answer = null;

// Message
message = null;

// Password prompt
bullets = null;
prompt = null;
bullet.image = Image.Text("*", 1, 1, 1);

// Flow
state.status = "play";
state.time = 0.0;

//--------------------------------- Refresh (Logo animation) --------------------------

# cycle through all images
for (i = 0; i < 7; i++)
  splash[i] = Image("splash-" + i + ".png");
for (i = 0; i < 12; i++)
  info[i] = Image("info-" + i + ".png");
current_sprite = Sprite();

# set image position
current_sprite.SetX(Window.GetX() + (Window.GetWidth(0) / 2 - splash[0].GetWidth() / 2)); # Place images in the center
current_sprite.SetY(Window.GetY() + (Window.GetHeight(0) / 2 - splash[0].GetHeight() / 2));

progress = 0;
stage = 0;

fun refresh_callback ()
  {
    if (stage == 0) {
      // 772
      if (progress < 82) current_sprite.SetImage(splash[0]);
      // 813
      else if (progress < 84) current_sprite.SetImage(splash[1]);
      // 814
      else if (progress < 86) current_sprite.SetImage(splash[2]);
      // 817
      else if (progress < 97) current_sprite.SetImage(splash[3]);
      // 843
      else if (progress < 149) current_sprite.SetImage(splash[4]);
      // 845
      else if (progress < 153) current_sprite.SetImage(splash[5]);
      // 891
      else if (progress < 245) current_sprite.SetImage(splash[6]);
      else {
        stage = 2;
        progress = 0;
      }
    } else {
      current_sprite.SetImage(info[6 + (Math.Int(progress / 30) % 4)]);
    }
    progress++;
  }
  
Plymouth.SetRefreshFunction (refresh_callback);

//------------------------------------- Password prompt -------------------------------
fun DisplayQuestionCallback(prompt, entry) {
  question = null;
  answer = null;

  if (entry == "")
      entry = "<answer>";

  question.image = Image.Text(prompt, 1, 1, 1);
  question.sprite = Sprite(question.image);
  question.sprite.SetX(screen.half.w - question.image.GetWidth() / 2);
  question.sprite.SetY(screen.h - 4 * question.image.GetHeight());

  answer.image = Image.Text(entry, 1, 1, 1);
  answer.sprite = Sprite(answer.image);
  answer.sprite.SetX(screen.half.w - answer.image.GetWidth() / 2);
  answer.sprite.SetY(screen.h - 2 * answer.image.GetHeight());
}
Plymouth.SetDisplayQuestionFunction(DisplayQuestionCallback);

//------------------------------------- Password prompt -------------------------------
fun DisplayPasswordCallback(nil, bulletCount) {
    state.status = "pause";
    totalWidth = bulletCount * bullet.image.GetWidth();
    startPos = screen.half.w - totalWidth / 2;

    prompt.image = Image.Text("Enter Password", 1, 1, 1);
    prompt.sprite = Sprite(prompt.image);
    prompt.sprite.SetX(screen.half.w - prompt.image.GetWidth() / 2);
    prompt.sprite.SetY(screen.h - 4 * prompt.image.GetHeight());

    // Clear all bullets (user might hit backspace)
    bullets = null;
    for (i = 0; i < bulletCount; i++) {
        bullets[i].sprite = Sprite(bullet.image);
        bullets[i].sprite.SetX(startPos + i * bullet.image.GetWidth());
        bullets[i].sprite.SetY(screen.h - 2 * bullet.image.GetHeight());
    }
}
Plymouth.SetDisplayPasswordFunction(DisplayPasswordCallback);

//--------------------------- Normal display (unset all text) ----------------------
fun DisplayNormalCallback() {
    state.status = "play";
    bullets = null;
    prompt = null;
    message = null;
    question = null;
    answer = null;
}
Plymouth.SetDisplayNormalFunction(DisplayNormalCallback);

//----------------------------------------- Message --------------------------------
fun MessageCallback(text) {
    message.image = Image.Text(text, 1, 1, 1);
    message.sprite = Sprite(message.image);
    message.sprite.SetPosition(screen.half.w - message.image.GetWidth() / 2, message.image.GetHeight());
}
Plymouth.SetMessageFunction(MessageCallback);
      '';
    };

    imgDir = ./img;

    unpackPhase = "true";
    buildPhase = ''
      themeDir="$out/share/plymouth/themes/soph-mes"
      mkdir -p $themeDir
      cp ${logo} $themeDir/logo.png
      cp $imgDir/info-{0..10}.png $themeDir/
      cp $imgDir/splash-{0..6}.png $themeDir/
      cp $src $themeDir/soph-mes.script
    '';

    installPhase = ''
      cat << EOF > $themeDir/soph-mes.plymouth
      [Plymouth Theme]
      Name=soph-mes
      ModuleName=script

      [script]
      ImageDir=$themeDir
      ScriptFile=$themeDir/soph-mes.script
      EOF
    '';
  }