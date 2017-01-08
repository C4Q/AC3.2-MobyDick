// bootstrap the jQuery library into any page we load
// I'm guessing this can have unpredictable results if jQuery is already there in a different
// version or something
var jQueryInclude = document.createElement('script')
jQueryInclude.setAttribute("src", "https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js");
document.body.appendChild(jQueryInclude);

function postProcess() {
    // change the background
    document.body.style.background = "#ccf";
    
    // this looks through every p (paragraph) tag, <p>, and replaces all occurrences of "Ishmael"
    // to "Joe".
    $("p").each(function() {
                    //$(this)
                   $(this).html($(this).html().replace('Ishmael', 'Joe'));
                   });

    
    // this looks through every p (paragraph) tag, <p>, and replaces all occurrences of "water"
    // to "fire" with a link to apple. It is meant to be an example of searching all tags of a document
    // and of replacing arbitrary text with HTML tags.
    // NOTE: the search for "water" is now a regular expression with those / characters as quotes and
    // ig qualifying the search to i=ignore case and be g=global.
    $("p").each(function() {
                //$(this)
                $(this).html($(this).html().replace(/water/ig, '<a href="https://apple.com">fire</a>'));
                });
    
    // this is one way you can replace text globally within an HTML page
    // it's a little less safe than the one above because it doesn't limit to a particular
    // set of tags. Be careful not to replace html code!
    // $("body").html($("body").html().replace(/water/ig,'mizu'));


    // this is where you should add/change the Javascript you write
    // to post-process pages you load
    $("p").each(function() {
                //$(this)
                $(this).html($(this).html().replace(/driving/ig, '<a href="https://apple.com">🚗</a>'));
                });
    
    $("p").each(function() {
                //$(this)
                $(this).html($(this).html().replace(/me/ig, '<img src="https://cdn0.iconfinder.com/data/icons/characters-colored/60/poppey-sailor-man-cartoon-avatar-128.png" border="5" height="25" width="25" />'));
                });

}

// setting window.onload guarantees the jQuery library will be loaded
// if we just called postProcess right here it wouldn't be, and would fail
window.onload = postProcess;
