import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: ViewModel

    private var dragGesture: some Gesture {
        DragGesture().onChanged { value in
            self.viewModel.player?.moveToPoint(value.location)
        }
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(self.viewModel.obstacles) { obstacle in
                    Image("vegati")
                            .resizable()
                            .scaledToFit()
                            .frame(width: obstacle.width, height: obstacle.height)
                            .position(obstacle.center)
                }

                Image("adria")
                        .frame(width: viewModel.player?.width, height: viewModel.player?.height)
                        .position(viewModel.player?.center ?? CGPoint())
                        .gesture(dragGesture)
            }
                    .edgesIgnoringSafeArea(.all)
                    .onAppear {
                        viewModel.createPlayer(center: CGPoint(x: geometry.size.width / 2, y: geometry.size.height - 100), width: 50, height: 50)
                        viewModel.createDisplayLink()
                    }

            if viewModel.gameOver {
                Text("GAME OVER")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            }
            Text("Score: \(viewModel.score)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.5))
                    .cornerRadius(10)
                    .position(x: geometry.size.width / 2, y: geometry.safeAreaInsets.top + 40)
        }
                .edgesIgnoringSafeArea(.all)
        }
    }




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ViewModel())
    }
}
