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
pub struct ExplorerSegment {
    /// The unique identifier of this segment
    #[serde(rename = "id", skip_serializing_if = "Option::is_none")]
    pub id: Option<i64>,
    /// The name of this segment
    #[serde(rename = "name", skip_serializing_if = "Option::is_none")]
    pub name: Option<String>,
    /// The category of the climb [0, 5]. Higher is harder ie. 5 is Hors catégorie, 0 is uncategorized in climb_category. If climb_category = 5, climb_category_desc = HC. If climb_category = 2, climb_category_desc = 3.
    #[serde(rename = "climb_category", skip_serializing_if = "Option::is_none")]
    pub climb_category: Option<i32>,
    /// The description for the category of the climb
    #[serde(rename = "climb_category_desc", skip_serializing_if = "Option::is_none")]
    pub climb_category_desc: Option<ClimbCategoryDesc>,
    /// The segment's average grade, in percents
    #[serde(rename = "avg_grade", skip_serializing_if = "Option::is_none")]
    pub avg_grade: Option<f32>,
    /// A pair of latitude/longitude coordinates, represented as an array of 2 floating point numbers.
    #[serde(rename = "start_latlng", skip_serializing_if = "Option::is_none")]
    pub start_latlng: Option<Vec<f32>>,
    /// A pair of latitude/longitude coordinates, represented as an array of 2 floating point numbers.
    #[serde(rename = "end_latlng", skip_serializing_if = "Option::is_none")]
    pub end_latlng: Option<Vec<f32>>,
    /// The segments's evelation difference, in meters
    #[serde(rename = "elev_difference", skip_serializing_if = "Option::is_none")]
    pub elev_difference: Option<f32>,
    /// The segment's distance, in meters
    #[serde(rename = "distance", skip_serializing_if = "Option::is_none")]
    pub distance: Option<f32>,
    /// The polyline of the segment
    #[serde(rename = "points", skip_serializing_if = "Option::is_none")]
    pub points: Option<String>,
}

impl ExplorerSegment {
    pub fn new() -> ExplorerSegment {
        ExplorerSegment {
            id: None,
            name: None,
            climb_category: None,
            climb_category_desc: None,
            avg_grade: None,
            start_latlng: None,
            end_latlng: None,
            elev_difference: None,
            distance: None,
            points: None,
        }
    }
}

/// The description for the category of the climb
#[derive(Clone, Copy, Debug, Eq, PartialEq, Ord, PartialOrd, Hash, Serialize, Deserialize)]
pub enum ClimbCategoryDesc {
    #[serde(rename = "NC")]
    Nc,
    #[serde(rename = "4")]
    Variant4,
    #[serde(rename = "3")]
    Variant3,
    #[serde(rename = "2")]
    Variant2,
    #[serde(rename = "1")]
    Variant1,
    #[serde(rename = "HC")]
    Hc,
}

impl Default for ClimbCategoryDesc {
    fn default() -> ClimbCategoryDesc {
        Self::Nc
    }
}

