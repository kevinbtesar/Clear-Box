<?php
/*
Template Name: Reset Password
 *
 * @package coral-dark
 */
ini_set('display_errors', 1);
get_header();

$output = "";

//echo $twitterObj;
//$arrayT = json_decode($twitterObj, true);
//var_dump($arrayT);

global $text_str;

//echo 'TEXTSTR: ' . $text_str;
global $wpdb;
//get listing of posts with a metadata value of 'reddit'

var_dump($_POST);

$email = "";
$code = "";
$error = "";

if (isset($_GET['code'])) {
    if (!empty($_GET['code'])) {
        $code = $_GET['code'];
    }

    if (!empty($_GET['email'])) {
        $email = $_GET['email'];
    }

}

if (isset($_POST["wpforms"]["fields"][0]["code"])) {

    if (!empty($_POST["wpforms"]["fields"][0]["code"])) {
        $code = $_POST["wpforms"]["fields"][0]["code"];
    }

    if (!empty($_POST["wpforms"]["fields"][0]["code"])) {
        $email = $_POST["wpforms"]["fields"][0]["email"];
    }

    if (!empty($_GET['code'])) {
        $code = $_GET['code'];
        $email = $_GET['email'];
    } else {
        $error = "Necessary data not found";
    }

    $fields = array(
        'email' => "kevinbtesar@gmail.com",
        'code' => $_POST["wpforms"]["fields"][0]["code"],

    );

    $fields = json_encode($fields);
    //print("\nJSON sent:\n");
    print($fields);

    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, "https://clearboxlending.com/wp-json/bdpwr/v1/reset-password");
    curl_setopt($ch, CURLOPT_HTTPHEADER, array(
        'Content-Type: application/json; charset=utf-8',
    ));
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_HEADER, false);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $fields);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);

    $response = curl_exec($ch);
    curl_close($ch);

    echo $response;
}

$redditResult = $wpdb->get_results("SELECT *
								FROM kevin_tweets ORDER BY id DESC LIMIT 1 ");

foreach ($redditResult as $r) {

    if ($id_str > $r->tweet_id) {

        echo 'ONE: ' . $r->tweet_id . ' TWO: ' . $id_str . ' THREE: ' . $text_str . '<br><br>';
        $redditResult = $wpdb->get_results(
            "INSERT INTO `kevin_tweets` (`id`, `timestamp`, `tweet_id`, `tweet_text`) VALUES (NULL, CURRENT_TIMESTAMP, '" . $id_str . "', '" . $text_str . "');"
        );

        echo $wpdb->last_query;
        $response = sendMessage($text_str);
        $return["allresponses"] = $response;
        $return = json_encode($return);

        $data = json_decode($response, true);
        print_r($data);
        $id = $data['id'];
        print_r($id);

        print("\n\nJSON received:\n");
        print($return);
        print("\n");
    }
}

echo '
<script type="text/javascript">
    var onloadCallback = function() {
        grecaptcha.render("html_element", {
            "sitekey" : "6LeMwaIZAAAAAD73OhrsKmgllwhZQNTOMf4n724d"
        });
    };
</script>

<div id="primary" class="content-area">
   <main id="main" class="site-main" role="main">
      <article id="post-117" class="post-117 page type-page status-publish hentry">
         <div class="entry-content"> ' . $output . '

            <div class="wpforms-container wpforms-container-full" id="wpforms-244">
               <form onsubmit="return validateRecaptcha();" id="identicalForm" class="password-strength form p-4 wpforms-validate wpforms-form wpforms-ajax-form needs-validation" data-formid="244" method="post" enctype="multipart/form-data" action="?" novalidate="novalidate">
                  <noscript class="wpforms-error-noscript">Please enable JavaScript in your browser to complete this form.</noscript>

                    <input type="hidden" name="code" value="' . $code . '">
                    <input type="hidden" name="email" value="' . $email . '">

                   

                    <form action="">
        <input id="password" type="password" name="password" value="" placeholder="Type here to check strength">
        <div class="strength_meter">
            <div data-meter="password"></div>
            <div class="info veryweak hide">
                <p class="uppercase"><span class="fail"></span> Uppercase Letters</p>
                <p class="lowercase"><span class="fail"></span> Lowercase Letters</p>
                <p class="number"><span class="fail"></span> Numbers</p>
                <p class="special"><span class="fail"></span> Symbols</p>
                <p class="length"><span class="fail"></span> Length must be greter than 8</p>
            </div>
        </div>
    </form>


                    
                    <div class="wpforms-field-container">
                        <div id="wpforms-244-field_0-container" class="wpforms-field wpforms-field-name" data-field-id="0">
                        <label class="wpforms-field-label" for="password_id">Password </label>
                        <div class="wpforms-field-row wpforms-field-medium">
                            <div class="wpforms-field-row-block wpforms-first wpforms-one-half">
                                <input
                                    type="password"
                                    id="password_id"
                                    class="wpforms-field-name-first wpforms-field-required form-control password-strength__input"
                                    name="wpforms[fields][0][code]
                                    required="required"
                                    style="background-image: url(&quot;data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAABHklEQVQ4EaVTO26DQBD1ohQWaS2lg9JybZ+AK7hNwx2oIoVf4UPQ0Lj1FdKktevIpel8AKNUkDcWMxpgSaIEaTVv3sx7uztiTdu2s/98DywOw3Dued4Who/M2aIx5lZV1aEsy0+qiwHELyi+Ytl0PQ69SxAxkWIA4RMRTdNsKE59juMcuZd6xIAFeZ6fGCdJ8kY4y7KAuTRNGd7jyEBXsdOPE3a0QGPsniOnnYMO67LgSQN9T41F2QGrQRRFCwyzoIF2qyBuKKbcOgPXdVeY9rMWgNsjf9ccYesJhk3f5dYT1HX9gR0LLQR30TnjkUEcx2uIuS4RnI+aj6sJR0AM8AaumPaM/rRehyWhXqbFAA9kh3/8/NvHxAYGAsZ/il8IalkCLBfNVAAAAABJRU5ErkJggg==&quot;);
                                    background-repeat: no-repeat;
                                    background-attachment: scroll;
                                    background-size: 16px 18px; background-position: 98% 50%; cursor: auto; width: 40%"
                                    required
                                    autofocus>
                            </div>
                        </div>
                        </div>
                    </div>

                    <div class="wpforms-field-container">
                        <div id="wpforms-244-field_0-container" class="wpforms-field wpforms-field-name" data-field-id="0">
                        <label class="wpforms-field-label" for="password_confirm_id">Confirm Password </label>
                        <div class="wpforms-field-row wpforms-field-medium">
                            <div class="wpforms-field-row-block wpforms-first wpforms-one-half">
                                <input
                                    type="password"
                                    id="password_confirm_id"
                                    class="wpforms-field-name-first wpforms-field-required form-control"
                                    name="confirm_password"
                                    required="required"
                                    style="background-image: url(&quot;data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAABHklEQVQ4EaVTO26DQBD1ohQWaS2lg9JybZ+AK7hNwx2oIoVf4UPQ0Lj1FdKktevIpel8AKNUkDcWMxpgSaIEaTVv3sx7uztiTdu2s/98DywOw3Dued4Who/M2aIx5lZV1aEsy0+qiwHELyi+Ytl0PQ69SxAxkWIA4RMRTdNsKE59juMcuZd6xIAFeZ6fGCdJ8kY4y7KAuTRNGd7jyEBXsdOPE3a0QGPsniOnnYMO67LgSQN9T41F2QGrQRRFCwyzoIF2qyBuKKbcOgPXdVeY9rMWgNsjf9ccYesJhk3f5dYT1HX9gR0LLQR30TnjkUEcx2uIuS4RnI+aj6sJR0AM8AaumPaM/rRehyWhXqbFAA9kh3/8/NvHxAYGAsZ/il8IalkCLBfNVAAAAABJRU5ErkJggg==&quot;);
                                    background-repeat: no-repeat;
                                    background-attachment: scroll;
                                    background-size: 16px 18px;
                                    background-position: 98% 50%; cursor: auto; width: 40%"
                                    required>
                            </div>
                        </div>
                        </div>
                    </div>

                    <!-- An element to toggle between password visibility -->
                    <input type="checkbox" onclick="myFunction()">&nbsp;&nbsp;&nbsp;Show Password

                    <br><br>
                    <div class="wpforms-recaptcha-container">
                    <div id="html_element"></div>

                    <br><br>
                    <div class="wpforms-submit-container"><input type="hidden" name="wpforms[id]" value="244"><input type="hidden" name="wpforms[author]" value="1"><input type="hidden" name="wpforms[post_id]" value="117"><button type="submit" name="wpforms[submit]" class="wpforms-submit black" id="wpforms-submit-244" value="wpforms-submit" aria-live="assertive" data-alt-text="Sending..." data-submit-text="Submit">Submit</button><img src="https://clearboxlending.com/wp-content/plugins/wpforms-lite/assets/images/submit-spin.svg" class="wpforms-submit-spinner" style="display: none;" width="26" height="26" alt=""></div>
			   </form>

            </div>
            <!-- .wpforms-container -->
			<p></p>

         </div>

      </article>
      <!-- #post-## -->
   </main>
   <!-- #main -->
</div>
';

?>

<script language="javascript">
function myFunction() {
    var p1 = document.getElementById("password_id");
    var p2 = document.getElementById("password_confirm_id");
    if (p1.type === "password") {
        p1.type = "text";
        p2.type = "test";
    } else {
        p1.type = "password";
        p2.type = "password";
    }
}

function validateRecaptcha() {
    var response = grecaptcha.getResponse();
    if (response.length === 0) {
        alert("Captcha must be validated");
        return false;
    } else {
        return true;
    }
}
</script>

<script src="https://www.google.com/recaptcha/api.js?onload=onloadCallback&render=explicit" async defer>
</script>



<link rel="stylesheet" href="<?php echo get_stylesheet_directory_uri(); ?>/password-strength/css/strength.css">

    <script type="text/javascript" src="<?php echo get_stylesheet_directory_uri(); ?>/password-strength/js/strength.js"></script>
    
<script type="text/javascript">
  jQuery(function($) {
        $('#password').strength();
  });
    </script>