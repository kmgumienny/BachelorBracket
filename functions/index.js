const functions = require('firebase-functions');

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });

function calcPickPts(){ //calculates points per pick (50/# women left)
    var pts = 0;
    var numWomen = 0;
    var remWomen = [];

    //loop through women and incr count for each remaining
    var query = firebase.database().ref('women').orderByKey();
    query.once("value")//database
        .then(function(snapshot){//women
            snapshot.forEach(function(childSnapshot){//individual woman (hannahann, madison, i.e.)
                var week = childSnapshot.child("week").val();//get week value
                var name = childSnapshot.child("name").val();//get name value
                if(week == 100){
                    numWomen += 1;//incr women who made it
                    remWomen.push(name)
                }
            })
        })

    //calc pts
    pts = 50 / numWomen;

    return pts, remWomen;
}

function calcUserScores(pts, remWomen) {//loop through users and update scores
    var score = 0;
    var numCorrect = 0;

    var query = firebase.database().ref('users').orderByKey();
    query.once("value")//database
        .then(function (snapshot) {//users
            snapshot.forEach(function (childSnapshot) {//individual user (julien, pete, i.e.)
                childSnapshot.forEach(function(c2Snapshot){//picks
                    c2Snapshot.forEach(function(c3Snapshot){//woman picked
                        var pickName = c3Snapshot.child("name").val();//get women name

                        for(var name in remWomen){
                            if(name == pickName){
                                numCorrect += 1;
                            }
                        }
                    })
                })
            })
        })


    //Calculate score
    score = numCorrect * pts;


    return score;
}

export const onScoringUpdate = functions.database
    .ref('admin/{adminId}')
    .onUpdate((change, context) => {
        const before = change.before.val()
        const after = change.after.val()

        var ptsPerPick, remWomen = calcPickPts();



        //get users weekly score
        var score = calcUserScores(ptsPerPick, remWomen);

        //update score
        

        return null
    })