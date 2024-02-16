/*
 * Strava API v3
 *
 * The [Swagger Playground](https://developers.strava.com/playground) is the easiest way to familiarize yourself with the Strava API by submitting HTTP requests and observing the responses before you write any client code. It will show what a response will look like with different endpoints depending on the authorization scope you receive from your athletes. To use the Playground, go to https://www.strava.com/settings/api and change your “Authorization Callback Domain” to developers.strava.com. Please note, we only support Swagger 2.0. There is a known issue where you can only select one scope at a time. For more information, please check the section “client code” at https://developers.strava.com/docs.
 *
 * The version of the OpenAPI document: 3.0.0
 * 
 * Generated by: https://openapi-generator.tech
 */




#[derive(Clone, Debug, PartialEq, Serialize, Deserialize)]
pub struct ClubActivity {
    #[serde(rename = "athlete", skip_serializing_if = "Option::is_none")]
    pub athlete: Option<Box<crate::models::MetaAthlete>>,
    /// The name of the activity
    #[serde(rename = "name", skip_serializing_if = "Option::is_none")]
    pub name: Option<String>,
    /// The activity's distance, in meters
    #[serde(rename = "distance", skip_serializing_if = "Option::is_none")]
    pub distance: Option<f32>,
    /// The activity's moving time, in seconds
    #[serde(rename = "moving_time", skip_serializing_if = "Option::is_none")]
    pub moving_time: Option<i32>,
    /// The activity's elapsed time, in seconds
    #[serde(rename = "elapsed_time", skip_serializing_if = "Option::is_none")]
    pub elapsed_time: Option<i32>,
    /// The activity's total elevation gain.
    #[serde(rename = "total_elevation_gain", skip_serializing_if = "Option::is_none")]
    pub total_elevation_gain: Option<f32>,
    #[serde(rename = "type", skip_serializing_if = "Option::is_none")]
    pub r#type: Option<crate::models::ActivityType>,
    #[serde(rename = "sport_type", skip_serializing_if = "Option::is_none")]
    pub sport_type: Option<crate::models::SportType>,
    /// The activity's workout type
    #[serde(rename = "workout_type", skip_serializing_if = "Option::is_none")]
    pub workout_type: Option<i32>,
}

impl ClubActivity {
    pub fn new() -> ClubActivity {
        ClubActivity {
            athlete: None,
            name: None,
            distance: None,
            moving_time: None,
            elapsed_time: None,
            total_elevation_gain: None,
            r#type: None,
            sport_type: None,
            workout_type: None,
        }
    }
}


