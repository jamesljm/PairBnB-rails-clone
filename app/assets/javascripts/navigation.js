/* jshint esversion: 6 */

// == Navigation AJAX search
$(document).on('turbolinks:load', () => {
    $("#search").keyup((e) => {

        // alert("key press");

        /**
         * @pre
         *    Require to target the search form
         * @post
         *    Submit post upon click and retrieve search data
         * @params - response
         *    Retrieve data from search
         */
        $("#list").html("");
        const form = $("#search-form");
        $.ajax({
            // send method
            method: "POST",
            // onto which routes
            url: "/search",
            // converting data into a format that the server understand
            data: form.serialize(),
            // rendering data type
            dataType: "json",
            success: function (response) {
                response.forEach((e) => {
                    console.log(e);
                    const option = document.createElement('option');
                    // debugger
                    option.value = e.name;
                    $("#list").append(option);
                });
            }
        });
    });

});
