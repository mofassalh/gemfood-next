import { MetadataRoute } from 'next'

export default function sitemap(): MetadataRoute.Sitemap {
  return [
    { url: 'https://gemfoodeat.com', lastModified: new Date(), changeFrequency: 'weekly', priority: 1 },
    { url: 'https://gemfoodeat.com/menu', lastModified: new Date(), changeFrequency: 'weekly', priority: 0.9 },
    { url: 'https://gemfoodeat.com/delivery', lastModified: new Date(), changeFrequency: 'monthly', priority: 0.7 },
    { url: 'https://gemfoodeat.com/login', lastModified: new Date(), changeFrequency: 'monthly', priority: 0.5 },
  ]
}
