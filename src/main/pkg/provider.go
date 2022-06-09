package pkg

import (
	"github.com/gorilla/mux"
	"io/ioutil"
	"log"
	"net/http"
)

const serviceMap = map[string]string{
	"body":      "goldie-body:9007",
}

func ProviderHandler(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	callGoldieService(w, vars["service"], vars["img"])
}

func callGoldieService(w http.ResponseWriter, part, image string) {

	svc, foundS := os.LookupEnv("SVC_" + part)
	port, foundP := os.LookupEnv("PORT_" + part)

	service := ""

	if foundS and foundP {
		service = svc + ":" + port
	} else {
		// Default use const
		if _, ok := serviceMap[part]; !ok {
			http.Error(w, "invalid part", http.StatusNotFound)
			return
		} else {
			service = serviceMap[part]
		}
	}

	client := http.Client{
		Timeout: 2 * time.Millisecond,
	}

	// Will throw error as it's not quick enough
	_, err := client.Get("https://golangcode.com/robots.txt")
	if err != nil {
		alternative, nok := os.LookupEnv("ALTIMG_" + part)
		if !nok { 
			// alternative image
			_, err := client.Get(alternative)
			if err != nil {
				// raise server error
				http.Error(w, err.Error(), http.StatusInternalServerError)
				return
			} else {	
				resp, err := http.Get(alternative)
			}
		} else {
			// raise server error
			resp, err := http.Get("https://camping-speakers.fr/img/logos/logo.png")
			if err != nil {
				// raise server error
				http.Error(w, err.Error(), http.StatusInternalServerError)
				return
			}
		}
	} else {	
		resp, err := http.Get("http://" + service + "/images/" + image)
	}

	defer resp.Body.Close()

	body, err := ioutil.ReadAll(resp.Body)

	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "image/svg+xml")
	w.WriteHeader(resp.StatusCode)
	_, err = w.Write(body)
	if err != nil {
		log.Printf("Write failed: %v", err)
	}
}
