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
                        .frame(width: viewModel.player?.width , height: viewModel.player?.height)
                        .position(viewModel.player?.center ?? CGPoint())
                        .gesture(dragGesture)

            }
                    // Play the song on appear
                    .onAppear() {
                        viewModel.playSound()
                    }

            HStack {
                Spacer()

                Button(action: {
                    if viewModel.isSound() {
                        viewModel.pauseSound()
                    } else {
                        viewModel.playSound()
                    }
                }) {
                    if viewModel.isSound() {
                        Image(systemName: "speaker.fill")
                                .font(.title)
                    } else {
                        Image(systemName: "speaker.slash.fill")
                                .font(.title)
                    }
                }
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(10)
                        .position(x: geometry.size.width - 60, y: geometry.size.height - 60) // Place at the bottom right
            }


                    .edgesIgnoringSafeArea(.all)
                    .onAppear {
                        viewModel.createPlayer(center: CGPoint(x: geometry.size.width / 2, y: geometry.size.height - 100), width: 50, height: 50)
                        viewModel.createDisplayLink()
                    }

            if viewModel.gameOver {
                VStack {
                    Text("GAME OVER")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                            .padding(.bottom)

                    Button(action: {
                        viewModel.restartGame()
                    }) {
                        Text("Restart")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                                .padding(.bottom)
                    }
                }
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            } else if viewModel.gameWon {
                VStack {
                    Text("YOU WON")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                            .padding(.bottom)

                    Button(action: {
                        viewModel.restartGame()
                    }) {
                        Text("Restart")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                                .padding(.bottom)
                    }
                }
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            }
            HStack {
                Text("Score: \(viewModel.score)")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(10)
                        .position(x: geometry.safeAreaInsets.leading + 100, y: geometry.safeAreaInsets.top + 50)
                        .offset(x: 10, y: 0)
                        .zIndex(1)

                Spacer()

                if viewModel.score < 100 {
                    Text("Level EASY")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                            .padding(.bottom)
                            .position(x: geometry.size.width - 300, y: geometry.safeAreaInsets.top + 60)
                            .offset(x: -20, y: 0)
                            .zIndex(1)
                } else if viewModel.score >= 100 {
                    Text("LEVEL HARD")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                            .padding(.bottom)
                            .position(x: geometry.size.width - 300, y: geometry.safeAreaInsets.top + 80)
                            .offset(x: -20, y: 0)
                            .zIndex(1)
                }

                Spacer()
            }


        }
                .edgesIgnoringSafeArea(.all)
        }
    }


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ViewModel())
    }
}
