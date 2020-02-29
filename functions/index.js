const admin = require('firebase-admin');
const functions = require('firebase-functions');

admin.initializeApp();
db = admin.firestore();

function calcPickPts() { //calculates points per pick (50/# women left)
    var pts = 0;
    var numWomen = 0;
    var remWomen = [];

    //query every remaining woman
    let query = db.collection("women").where('week', '==', 100).get()
        .then(snapshot => {
            if (snapshot.empty) {
                console.log('No matching documents.');
                return;
            }
            // loop through each woman
            snapshot.forEach(doc => {
                numWomen++;
                remWomen.push(doc.id)
            });

            // return statement inside promise because async
            pts = 50 / numWomen;
            var score = calcUserScores(pts, remWomen)
            return score;

        })
        .catch(err => {
            console.log('Error getting documents', err);
        });
    
}

    

async function calcUserScores(pts, remWomen) { //loop through users and update scores
    var score = 0;
    var numCorrect = 0;

    // query users
    let query = db.collection("users").get()
        .then(snapshot => {
            
            // error handling
            if (snapshot.empty) {
                console.log('No matching documents.');
                return;
            }

            // loop through each user
            snapshot.forEach(doc => {

                for(var cd in doc.data().picks) { // loops through user picks
                    doc.data().picks[cd].get()
                    .then(childSnapshot => {
                        pickName = childSnapshot.id;
                        
                        // check if pick is in remWomen
                        for(var woman in remWomen){
                            if(remWomen[woman] == pickName){
                                numCorrect ++; // incr
                            }
                        }
                    });
                    // assign score to user
                    newScore = numCorrect * pts
                    console.log(score)
                    // /updateUserPoints(week, currScore, newScore)
                }
                
            })

        })

        .catch(err => {
            console.log('Error getting documents', err);
        });

    /*
    var query = firebase.database().ref('users').orderByKey();
    query.once("value")//database
        .then(function (snapshot) {//users
            snapshot.forEach(function (childSnapshot) {//individual user (julien, pete, i.e.)
                for(var cd in childSnapshot.child("picks")){//for each woman

                    var pickName = cd.child("name").val();//get womans name
                    for(var name in remWomen){
                        if(name == pickName){
                            numCorrect += 1;
                        }
                    }

                }
            })
        })


    //Calculate score
    score = numCorrect * pts;


    return score;
    */
   return -1
}

exports.onScoringUpdate = functions.firestore
    .document('admin/{adminID}')
    .onUpdate((change, context) => {

        console.log('running calcPickPts function....');
        var score = calcPickPts();



        /*update score
        var admin = require("firebase-admin");
        var db = admin.database();
        var ref = db.ref("users");
        var i = 0
        for(var cd in ref){
            var prevScores = cd.child("scores").val();
            console.log(prevScores)
            prevScores.push(score[i])
            cd.update({
                points: [prevScores],
                total: prevScores.reduce((a, b) => a + b, 0)
            });
            i += 1;
        }
        */
        
        return null
})
