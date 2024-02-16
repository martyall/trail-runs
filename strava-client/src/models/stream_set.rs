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
pub struct StreamSet {
    #[serde(rename = "time", skip_serializing_if = "Option::is_none")]
    pub time: Option<Box<crate::models::TimeStream>>,
    #[serde(rename = "distance", skip_serializing_if = "Option::is_none")]
    pub distance: Option<Box<crate::models::DistanceStream>>,
    #[serde(rename = "latlng", skip_serializing_if = "Option::is_none")]
    pub latlng: Option<Box<crate::models::LatLngStream>>,
    #[serde(rename = "altitude", skip_serializing_if = "Option::is_none")]
    pub altitude: Option<Box<crate::models::AltitudeStream>>,
    #[serde(rename = "velocity_smooth", skip_serializing_if = "Option::is_none")]
    pub velocity_smooth: Option<Box<crate::models::SmoothVelocityStream>>,
    #[serde(rename = "heartrate", skip_serializing_if = "Option::is_none")]
    pub heartrate: Option<Box<crate::models::HeartrateStream>>,
    #[serde(rename = "cadence", skip_serializing_if = "Option::is_none")]
    pub cadence: Option<Box<crate::models::CadenceStream>>,
    #[serde(rename = "watts", skip_serializing_if = "Option::is_none")]
    pub watts: Option<Box<crate::models::PowerStream>>,
    #[serde(rename = "temp", skip_serializing_if = "Option::is_none")]
    pub temp: Option<Box<crate::models::TemperatureStream>>,
    #[serde(rename = "moving", skip_serializing_if = "Option::is_none")]
    pub moving: Option<Box<crate::models::MovingStream>>,
    #[serde(rename = "grade_smooth", skip_serializing_if = "Option::is_none")]
    pub grade_smooth: Option<Box<crate::models::SmoothGradeStream>>,
}

impl StreamSet {
    pub fn new() -> StreamSet {
        StreamSet {
            time: None,
            distance: None,
            latlng: None,
            altitude: None,
            velocity_smooth: None,
            heartrate: None,
            cadence: None,
            watts: None,
            temp: None,
            moving: None,
            grade_smooth: None,
        }
    }
}

