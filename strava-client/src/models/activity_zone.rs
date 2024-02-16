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
pub struct ActivityZone {
    #[serde(rename = "score", skip_serializing_if = "Option::is_none")]
    pub score: Option<i32>,
    /// Stores the exclusive ranges representing zones and the time spent in each.
    #[serde(rename = "distribution_buckets", skip_serializing_if = "Option::is_none")]
    pub distribution_buckets: Option<Vec<crate::models::TimedZoneRange>>,
    #[serde(rename = "type", skip_serializing_if = "Option::is_none")]
    pub r#type: Option<Type>,
    #[serde(rename = "sensor_based", skip_serializing_if = "Option::is_none")]
    pub sensor_based: Option<bool>,
    #[serde(rename = "points", skip_serializing_if = "Option::is_none")]
    pub points: Option<i32>,
    #[serde(rename = "custom_zones", skip_serializing_if = "Option::is_none")]
    pub custom_zones: Option<bool>,
    #[serde(rename = "max", skip_serializing_if = "Option::is_none")]
    pub max: Option<i32>,
}

impl ActivityZone {
    pub fn new() -> ActivityZone {
        ActivityZone {
            score: None,
            distribution_buckets: None,
            r#type: None,
            sensor_based: None,
            points: None,
            custom_zones: None,
            max: None,
        }
    }
}

/// 
#[derive(Clone, Copy, Debug, Eq, PartialEq, Ord, PartialOrd, Hash, Serialize, Deserialize)]
pub enum Type {
    #[serde(rename = "heartrate")]
    Heartrate,
    #[serde(rename = "power")]
    Power,
}

impl Default for Type {
    fn default() -> Type {
        Self::Heartrate
    }
}
