//
//  dyerlab.org                                          @dyerlab
//                      _                 _       _
//                   __| |_   _  ___ _ __| | __ _| |__
//                  / _` | | | |/ _ \ '__| |/ _` | '_ \
//                 | (_| | |_| |  __/ |  | | (_| | |_) |
//                  \__,_|\__, |\___|_|  |_|\__,_|_.__/
//                        |_ _/
//
//         Making Population Genetic Software That Doesn't Suck
//
//  GenotypeView.swift
//
//
//  Created by Rodney Dyer on 5/10/22.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <https://www.gnu.org/licenses/>.

import SwiftUI

struct GenotypeView: View {
    @Binding var genotype: Genotype
    @State var reduced: Bool

    var body: some View {
        if reduced && genotype.masking == .MotherLeft {
            Text(String(":\(genotype.right)"))
        } else if reduced && genotype.masking == .MotherRight {
            Text(String("\(genotype.left):"))
        } else if reduced && genotype.masking == .Undefined {
            Text(String("\(genotype.left):\(genotype.right)"))
                .foregroundColor(.red)
        } else {
            Text(String("\(genotype.left):\(genotype.right)"))
        }
    }
}

struct GenotypeView_Previews: PreviewProvider {
    static var previews: some View {
        GenotypeView(genotype: .constant(Genotype.DefaultNULL()), reduced: false)
        GenotypeView(genotype: .constant(Genotype.DefaultHaploid()), reduced: false)
        GenotypeView(genotype: .constant(Genotype.DefaultHomozygote()), reduced: false)
        GenotypeView(genotype: .constant(Genotype.DefaultHeterozygote()), reduced: true)
        GenotypeView(genotype: .constant(Genotype.DefaultHeterozygoteMomLeft()), reduced: true)
        GenotypeView(genotype: .constant(Genotype.DefaultHeterozygoteMomRight()), reduced: true)
        GenotypeView(genotype: .constant(Genotype.DefaultHeterozygoteUndefined()), reduced: true)
    }
}
