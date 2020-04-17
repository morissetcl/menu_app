JUSTEAT_CITIES = ['https://www.just-eat.fr/restaurants-livraison-a-domicile/zone-livraison/lyon-bellecour',
                  'https://www.just-eat.fr/restaurants-livraison-a-domicile/zone-livraison/nice-medecin',
                  'https://www.just-eat.fr/restaurants-livraison-a-domicile/zone-livraison/lille-centre',
                  'https://www.just-eat.fr/restaurants-livraison-a-domicile/zone-livraison/grenoble-hyper-centre',
                  'https://www.just-eat.fr/restaurants-livraison-a-domicile/zone-livraison/strasbourg-neudorf-schluthfeld',
                  'https://www.just-eat.fr/restaurants-livraison-a-domicile/zone-livraison/toulouse-capitole',
                  'https://www.just-eat.fr/restaurants-livraison-a-domicile/zone-livraison/montpellier-centre-historique',
                  'https://www.just-eat.fr/restaurants-livraison-a-domicile/zone-livraison/marseille-01',
                  'https://www.just-eat.fr/restaurants-livraison-a-domicile/zone-livraison/nantes-haut-paves-st-felix',
                  'https://www.just-eat.fr/restaurants-livraison-a-domicile/zone-livraison/lyon-laennec',
                  'https://www.just-eat.fr/restaurants-livraison-a-domicile/zone-livraison/nancy-poincare']


PARIS = (10..26).to_a.map do |page|
  "https://www.just-eat.fr/restaurants-livraison-a-domicile/zone-livraison/paris-#{page}"
end
