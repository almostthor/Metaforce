/***************************************
 * Voting Animations
 ***************************************/

if(typeof Effect == 'undefined')
    throw("vote.js requires including script.aculo.us' effects.js library");

function setVoteStatusMsg(msg) {
    window.status = (msg == null ? '' : msg);
    return true;
}

function animateVoteButton(buttonElementIds, floaterId, voteButtonId, voteAbsValue, voteType, updatedVotedButtons, voteTotal, voteRerender) {
	var voteValue = (voteType == 'Up' ? '+' : '-') + voteAbsValue;

    var floater = $(floaterId);
    floater.update(voteValue);
    floater.style.visibility='';

    window.status = '';

    // hide the vote button
    for (var i = 0; i < buttonElementIds.length; i++) {
        var button = $(buttonElementIds[i]);
        if (button) {
            button.hide();
        }
    }
    
    // show the "voted" buttons
    for (var i = 0; i < updatedVotedButtons.length; i++) {
        var icon = $(updatedVotedButtons[i]);
        if (icon) {
            icon.show();
        }
    }
    
    // update the vote score and change its CSS class name
    var voteTotalElement = $(voteTotal);
    var voteTotal = parseInt(voteTotalElement.innerHTML, 10);
    if (!isNaN(voteTotal)) {
        if (voteType == 'Up') {
            voteTotalElement.update(voteTotal + 10);
        } else {
            voteTotalElement.update(voteTotal - 10);
        }
    }
    
    // update vote container style
    var voteRerenderElement = $(voteRerender);
    if (voteRerenderElement) {
        var voteStyleElement = $(voteRerenderElement).down(".baseVoteButton");
        if (voteStyleElement) {
            voteStyleElement.className = voteType == 'Up' ? 'baseVotedButton baseVotedUpButton' : 'baseVotedButton baseVotedDownButton';
        }   
    }
    
    // run the animation effect
    var durationSeconds = 2.5;
    new Effect.Fade(floaterId, {duration: durationSeconds});

    // convert to "voted" button
    if (voteType == 'Up') {
        new Effect.Move(floaterId, { x:  0, y: -45, duration: durationSeconds, mode: 'relative'});
    } else {
        new Effect.Move(floaterId, { x:  0, y: +25, duration: durationSeconds, mode: 'relative'});
    }
}

function incrementUserStatsVoteCount() {
  var currentVoteCount = parseInt($("userStatsVoteCount").innerHTML);
  if (!isNaN(currentVoteCount)) {
    $("userStatsVoteCount").update((currentVoteCount + 1) + '');
  }
}
