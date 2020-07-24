;
(function($, window, document, undefined) {
    var pluginName = 'strength';

    function Plugin(element, options) {
        this.element = element;
        this.$elem = $(this.element);
        this.options = $.extend({}, options);
        this._name = pluginName;
        this.init();
    }

    Plugin.prototype = { init: function() {
        var characters = 0;
        var capitalletters = 0;
        var loweletters = 0;
        var number = 0;
        var special = 0;
        var total = 0;
        var totalpercent = 0;
        var upperCase = new RegExp(/[A-Z]/g);
        var lowerCase = new RegExp(/[a-z]/g);
        var numbers = new RegExp(/[0-9]/g);
        var specialchars = new RegExp(/[^a-zA-Z0-9_]/g);

        function GetPercentage(a, b) {
            return ((b / a) * 100);
        }

        function check_strength(thisval, thisid) {

            if (thisval.length >= 8 && thisval.length < 16) {
                characters = 1;
                $('.info p.length span').addClass('pass').removeClass('exceed').removeClass('fail');
            } else if (thisval.length >= 16) {
                characters = 1;
                $('.info p.length span').addClass('exceed').removeClass('pass').removeClass('fail');
            } else { 
                characters = 0;
                $('.info p.length span').addClass('fail').removeClass('exceed').removeClass('pass');
            };

            if (thisval.match(upperCase)) {

                capitalletters = 0;
                $.each(thisval.match(upperCase),function(i,v){
                    capitalletters = capitalletters + 1;
                });

                if(capitalletters == 1) {
                    $('.info p.uppercase span').addClass('pass').removeClass('exceed').removeClass('fail');
                } else if(capitalletters > 1) {
                    $('.info p.uppercase span').addClass('exceed').removeClass('pass').removeClass('fail');
                }

            } else {
                capitalletters = 0;
                $('.info p.uppercase span').addClass('fail').removeClass('exceed').removeClass('pass');
            };

            if (thisval.match(lowerCase)) {
                loweletters = 0;
                $.each(thisval.match(lowerCase),function(i,v){
                    loweletters = loweletters + 1;
                });

                if(loweletters == 1) {
                    $('.info p.lowercase span').addClass('pass').removeClass('exceed').removeClass('fail');
                } else if(loweletters > 1) {
                    $('.info p.lowercase span').addClass('exceed').removeClass('pass').removeClass('fail');
                }

                
            } else {
                loweletters = 0;
                $('.info p.lowercase span').addClass('fail').removeClass('exceed').removeClass('pass');
            };

            if (thisval.match(numbers)) {
                number = 0;
                $.each(thisval.match(numbers),function(i,v){
                    number = number + 1;
                });

                if(number == 1) {
                    $('.info p.number span').addClass('pass').removeClass('exceed').removeClass('fail');
                } else if(number > 1) {
                    $('.info p.number span').addClass('exceed').removeClass('pass').removeClass('fail');
                }

            } else {
                $('.info p.number span').addClass('fail').removeClass('exceed').removeClass('pass');
                number = 0;
            };

            if (thisval.match(specialchars)) {
                special = 0;
                $.each(thisval.match(specialchars),function(i,v){
                    special = special + 1;
                });

                if(special == 1) {
                    $('.info p.special span').addClass('pass').removeClass('exceed').removeClass('fail');
                } else if(special > 1) {
                    $('.info p.special span').addClass('exceed').removeClass('pass').removeClass('fail');
                }

            } else {
                $('.info p.special span').addClass('fail').removeClass('exceed').removeClass('pass');
                special = 0;
            };

            total = characters + capitalletters + loweletters + number + special;
            totalpercent = GetPercentage(17, total).toFixed(0);
            get_total(totalpercent, thisid);
        }

        function get_total(totalpercent, thisid) {
            var thismeter = $('div[data-meter="' + thisid + '"]');
            var thisinfo = $('.strength_meter div.info');
            if (totalpercent == 0) {
                thismeter.removeClass().html('');
                thisinfo.addClass('veryweak').removeClass('weak').removeClass('normal').removeClass('medium').removeClass('strong');
            } 
            else if (totalpercent <= 10) {
                thismeter.removeClass();
                thismeter.addClass('veryweak');
                thisinfo.addClass('veryweak').removeClass('weak').removeClass('normal').removeClass('medium').removeClass('strong');
            } else if (totalpercent <= 40) {
                thismeter.removeClass();
                thismeter.addClass('weak');
                thisinfo.addClass('weak').removeClass('veryweak').removeClass('normal').removeClass('medium').removeClass('strong');
            } else if (totalpercent <= 50) {
                thismeter.removeClass();
                thismeter.addClass('normal');
                thisinfo.addClass('normal').removeClass('veryweak').removeClass('weak').removeClass('medium').removeClass('strong');
            } else if (totalpercent <= 95) {
                thismeter.removeClass();
                thismeter.addClass('medium');
                thisinfo.addClass('medium').removeClass('veryweak').removeClass('weak').removeClass('normal').removeClass('strong');
            } else {
                thismeter.removeClass();
                thismeter.addClass('strong');
                thisinfo.addClass('strong').removeClass('veryweak').removeClass('weak').removeClass('normal').removeClass('medium');
            }
        }

        thisid = this.$elem.attr('id');
        this.$elem.bind('keyup keydown', function(event) {
            thisval = $('#' + thisid).val();
            check_strength(thisval, thisid);
        });

        $(document).bind('keyup keydown focus click', function(e){
            if(e.target.id == 'password') $('.strength_meter div.info').removeClass('hide');
            else $('.strength_meter div.info').addClass('hide');
        });
        $(document).bind('blur focusout', function(e){
            if(e.target.id == 'password') $('.strength_meter div.info').addClass('hide');
        });

        },
    };

    $.fn[pluginName] = function(options) {
        return this.each(function() { new Plugin(this, options); });
    }; 

})(jQuery, window, document);
