//
//  ViewController.swift
//  AppAratech
//
//  Created by alvaro Landa Hidalgo on 7/8/21.
//

import UIKit
import SDWebImage

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITabBarDelegate, UITabBarControllerDelegate,UISearchBarDelegate {
    
    @IBOutlet weak var MovieTableView: UITableView!
    
    @IBOutlet weak var SearchBar: UISearchBar!
    @IBOutlet weak var tabBar: UITabBar!
    
//    movies es donde se guardan las peliculas una vez descargadas
//    En moviesFav guardamos todas aquellas peliculas favoritas que se mostrarán en la siguiente pantalla
//    filtered movies es donde se van a guardar las peliculas que coincidan con la búsqueda
    
    var movies = [Movie]()
    var moviesFav = [Movie]()
    var filteredMovies = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MovieTableView.delegate = self
        MovieTableView.dataSource = self
        tabBar.delegate = self
        
        SearchBar.delegate = self
        
        tabBar.tintColor = .red
//        declaramos el método para traer las peliculas de la API, la
        DataProvider.getInhabitant(){(data:[Movie]) -> Void in
            self.movies = data
            self.filteredMovies = self.movies
            self.MovieTableView.reloadData()
        }
    }

//Control del guardado y borrado de los extras guardados, en función si el objeto tiene la propiedad favorite en un estado u otro
    @objc func SaveFav(sender: UIButton){
        print("Tap in fav in serie \(sender.tag)")
        if filteredMovies[sender.tag].favorite == true{
            moviesFav.remove(at: sender.tag)
            filteredMovies[sender.tag].favorite = false
            movies[sender.tag].favorite = false
        }else{
            moviesFav.append(filteredMovies[sender.tag])
            filteredMovies[sender.tag].favorite = true
            movies[sender.tag].favorite = true
        }
        MovieTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredMovies.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        Definimos cada celda con los datos traidos de la API
        
        let identifier = "MovieCell"
        let firstparturl = "https://image.tmdb.org/t/p/w500/"
        
        let cell: MovieCell = tableView.dequeueReusableCell(withIdentifier: identifier,  for:indexPath) as! MovieCell
        let posterPath = firstparturl + self.filteredMovies[indexPath.row].poster_path
        
        cell.MovieImage.sd_setImage(with: URL(string: posterPath))
        cell.MovieTitle.text = self.filteredMovies[indexPath.row].title
        cell.DesciptionCell.text = self.filteredMovies[indexPath.row].overview
        cell.FavButton.contentMode = .scaleAspectFit
        
        cell.FavButton.tag = indexPath.row
        cell.FavButton.addTarget(self, action: #selector(SaveFav(sender:)),for: .touchUpInside)
        if self.filteredMovies[indexPath.row].favorite == false{
            cell.FavButton.setImage(UIImage(named: "Icono favorito estado 1.png"), for: .normal)
            
        }else{
            cell.FavButton.setImage(UIImage(named: "Icono favorito estado 2.png"), for: .normal)

        }
        return cell
    }
//    Cuando se hafa drag down a la table view, el teclado se esconderá para poder acceder a la tabbar. Si usamos view.endediting como seria normal, se deshabilita la interacción con el tabbar
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        SearchBar.endEditing(true)
    }
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 0 {
            /*
            self.dismiss(animated: true, completion: { [self] in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                vc.movies = self.movies
            self.present(vc, animated: true)
            })
            */
        }else if item.tag == 1 {
//            si seleccionamos el segundo elemento de la tabbar, el array con las peliculas favoritas se guardan en el array contendor de la vista
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "FavViewController") as! FavViewController
            vc.FavArray = moviesFav
            self.present(vc, animated: true)
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//      limpiamos el array de peliculas filtradas por si habia una búsqueda previa
        filteredMovies =  []
        if searchText == "" {
//          cuando queramos volver a hacer una busqueda y esté en blanco, la lista de peliculas se rellenará con todas
            filteredMovies = movies
            MovieTableView.reloadData()
        }else{
//            cuando se empiece a rellenar empezará a comparar el texto con los titulos de cada pelicula
            for movie in movies{
                if movie.title.lowercased().contains(searchText.lowercased()){
                    filteredMovies.append(movie)
                }
            }
        }
        self.MovieTableView.reloadData()
    }
}
