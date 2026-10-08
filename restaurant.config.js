/**
 * Restaurant Configuration
 * Change these values to white-label this app for a new restaurant
 */
module.exports = {
  // Restaurant Info
  name: "Gem Food",
  tagline: "100% Halal Food",
  description: "100% halal food, made fresh in St. Petersburg, Florida.",
  
  // Brand Colors
  primaryColor: "#F26A1B",
  darkColor: "#1A1A1A",
  
  // Contact
  phone: "+1 727-954-0001",
  email: "hello@angiesknb.com",
  website: "https://gemfoodeat.com",
  
  // Social
  instagram: "https://instagram.com/angiesknb",
  facebook: "https://facebook.com/angiesknb",
  
  // Locations
  locations: [
    { name: "St. Petersburg", address: "2800 38th Ave N, St. Petersburg, FL 33713" },
  ],
  
  // Features
  hasDelivery: true,
  hasPickup: true,
  hasLoyalty: true,
  hasCoupons: true,
  
  // Supabase (set in .env.local)
  // NEXT_PUBLIC_SUPABASE_URL
  // NEXT_PUBLIC_SUPABASE_ANON_KEY
}
