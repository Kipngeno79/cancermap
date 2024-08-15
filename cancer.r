# Install packages if not already installed
install.packages("leaflet")
install.packages("sf")
install.packages("dplyr")  # For data manipulation
install.packages("htmlwidgets") # Install htmlwidgets if not already installed



# Load necessary libraries
library(leaflet)
library(sf)
library(dplyr)
library(htmlwidgets)

# Generate sample data for breast cancer patients in Nairobi
set.seed(123)  # For reproducibility
nairobi_patients <- data.frame(
  longitude = runif(100, min = 36.6, max = 37.2),
  latitude = runif(100, min = -1.5, max = -1.1),
  intensity = runif(100, min = 1, max = 10)  # Represents number of patients
)

# Convert to a spatial data frame
nairobi_patients_sf <- st_as_sf(nairobi_patients, coords = c("longitude", "latitude"), crs = 4326)

# Define a color palette function based on intensity
pal <- colorNumeric(palette = "Reds", domain = nairobi_patients_sf$intensity)

# Create the leaflet map
nairobi_map <- leaflet(data = nairobi_patients_sf) %>%
  addTiles() %>%
  addCircleMarkers(
    radius = ~sqrt(intensity) * 3,  # Adjust the radius for better visualization
    color = ~pal(intensity),
    fillOpacity = 0.5,
    stroke = FALSE,
    label = ~paste("Patients:", intensity)
  ) %>%
  addLegend(
    position = "bottomright",
    pal = pal,
    values = ~intensity,
    title = "Intensity of Breast Cancer Cases",
    opacity = 1
  )

# Display the map
nairobi_map

# Save the map to an HTML file
saveWidget(nairobi_map, file = "nairobi_breast_cancer_heatmap.html", selfcontained = TRUE)