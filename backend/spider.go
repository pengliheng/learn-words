package main

import (
	"log"
	"net/http"
	"net/url"

	"github.com/PuerkitoBio/goquery"
)

func getImage(keyWord string) []string {
	res, err := http.Get("https://www.bing.com/images/search?q=" + url.PathEscape(keyWord) + "&first=1&scenario=ImageBasicHover&cw=1117&ch=1009")
	if err != nil {
		log.Fatal(err)
	}
	defer res.Body.Close()
	if res.StatusCode != 200 {
		log.Fatalf("status code error: %d %s", res.StatusCode, res.Status)
	}
	doc, err := goquery.NewDocumentFromReader(res.Body)
	if err != nil {
		log.Fatal(err)
	}
	images := []string{}
	doc.Find(".item img").Each(func(i int, s *goquery.Selection) {
		src, isExist := s.Attr("src")
		if isExist {
			images = append(images, src)
		}
	})
	return images
}
